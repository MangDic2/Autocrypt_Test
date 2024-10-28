//
//  PrecipitationView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class PrecipitationView: UIView {
    let selectedCityCoordinates = BehaviorRelay<Coordinates?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "강수량"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private lazy var mapView = MKMapView().then {
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        setupLayout()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        backgroundColor = #colorLiteral(red: 0.2973938584, green: 0.4899712801, blue: 0.7369740605, alpha: 0.7)
        layer.cornerRadius = 15
    }
    
    private func setupLayout() {
        addSubviews([descriptionLabel, mapView])
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(15)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(mapView.snp.width)
        }
    }
    
    private func bindState() {
        selectedCityCoordinates
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] coordinates in
                guard let self = self else { return }
                self.moveCamera(to: coordinates)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - MKMapView Delegate

extension PrecipitationView: MKMapViewDelegate {
    private func moveCamera(to coordinates: Coordinates) {
        let coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "CustomMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.glyphImage = UIImage(systemName: "location.fill")
        annotationView?.markerTintColor = .blue
        
        return annotationView
    }
}
