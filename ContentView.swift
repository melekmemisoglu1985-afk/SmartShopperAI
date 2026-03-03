import SwiftUI

struct ContentView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 15) {
                    if let objectName = cameraViewModel.detectedObjectName {
                        Text(objectName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    if cameraViewModel.isLoadingPrices {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Fiyatlar aranıyor...")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                    }
                    
                    if !cameraViewModel.prices.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("En Ucuz Fiyat")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            ForEach(cameraViewModel.prices.prefix(5)) { price in
                                HStack {
                                    Text(price.storeName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(price.price)
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 5)
                                
                                if price.id != cameraViewModel.prices.prefix(5).last?.id {
                                    Divider()
                                        .background(Color.white.opacity(0.3))
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    cameraViewModel.capturePhoto()
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 80, height: 80)
                        )
                }
                .padding(.bottom, 30)
            }
        }
    }
}
