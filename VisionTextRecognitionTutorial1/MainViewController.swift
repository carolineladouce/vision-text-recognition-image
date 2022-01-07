//
//  ViewController.swift
//  VisionTextRecognitionTutorial1
//
//  Created by Caroline LaDouce on 1/6/22.
//

import Vision
import UIKit

class MainViewController: UIViewController {
    
    private let outputTextLabel: UILabel = {
        let outputTextLabel = UILabel()
        outputTextLabel.numberOfLines = 0
        outputTextLabel.textAlignment = .center
        outputTextLabel.backgroundColor = .systemGray5
        outputTextLabel.text = "..."
        return outputTextLabel
        
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Receipt1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(outputTextLabel)
        view.addSubview(imageView)
        
        recognizeText(image: imageView.image)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.frame.size.width - 40, height: view.frame.size.width - 40)
        outputTextLabel.frame = CGRect(x: 20, y: view.frame.size.width + view.safeAreaInsets.top, width: view.frame.size.width - 40, height: 300)
    }
    
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get cgImage")
        }
        
        // Create handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        
        // Create request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                      return
                  }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            DispatchQueue.main.async {
                self?.outputTextLabel.text = text
            }
        } // End create request
        
        
        // Process request
        do {
            try handler.perform([request])
        }
        catch {
            outputTextLabel.text = "ERROR OCCURRED: \(error)"
        }
        
        
        
    } // End func
    
    
}

