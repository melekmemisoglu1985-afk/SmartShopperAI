import SwiftUI
import AVFoundation
import Vision

class CameraViewModel: NSObject, ObservableObject {
    @Published var detectedObjectName: String?
    @Published var session = AVCaptureSession()
    @Published var prices: [ProductPrice] = []
    @Published var isLoadingPrices = false
    
    private let priceScraperService = PriceScraperService()
    
    private let photoOutput = AVCapturePhotoOutput()
    private var currentPhotoData: Data?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        session.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
        } catch {
            print("Kamera hatası: \(error.localizedDescription)")
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func analyzeImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let request = VNRecognizeAnimalsRequest { [weak self] request, error in
            if let error = error {
                print("Vision hatası: \(error.localizedDescription)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedObjectObservation],
                  let topResult = observations.first else {
                self?.detectObjects(in: ciImage)
                return
            }
            
            DispatchQueue.main.async {
                let objectName = topResult.labels.first?.identifier ?? "Bilinmeyen Hayvan"
                self?.detectedObjectName = objectName
                self?.searchPrices(for: objectName)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("İstek hatası: \(error.localizedDescription)")
            }
        }
    }
    
    private func detectObjects(in image: CIImage) {
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            if let error = error {
                print("Yüz algılama hatası: \(error.localizedDescription)")
                return
            }
            
            if let observations = request.results as? [VNFaceObservation], !observations.isEmpty {
                DispatchQueue.main.async {
                    self?.detectedObjectName = "İnsan Yüzü"
                    self?.prices = []
                }
            } else {
                self?.classifyImage(image)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("İstek hatası: \(error.localizedDescription)")
            }
        }
    }
    
    private func classifyImage(_ image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            DispatchQueue.main.async { [weak self] in
                self?.detectedObjectName = "Model yüklenemedi"
            }
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let error = error {
                print("Sınıflandırma hatası: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            
            DispatchQueue.main.async {
                let objectName = topResult.identifier
                self?.detectedObjectName = objectName
                self?.searchPrices(for: objectName)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("İstek hatası: \(error.localizedDescription)")
            }
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Fotoğraf işleme hatası: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        analyzeImage(image)
    }
}

    
    func searchPrices(for productName: String) {
        isLoadingPrices = true
        prices = []
        
        Task {
            let foundPrices = await priceScraperService.searchPrices(for: productName)
            
            DispatchQueue.main.async { [weak self] in
                self?.prices = foundPrices
                self?.isLoadingPrices = false
            }
        }
    }
