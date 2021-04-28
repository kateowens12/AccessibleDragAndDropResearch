//
//  DragAndDropViewController.swift
//  DragAndDrop
//
//  Created by Kate Owens on 4/28/21.
//
import MobileCoreServices
import UIKit

@available(iOS 11.0, *)
class DragAndDropViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate {

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    lazy var davidSPumpkinsPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DavidSPumpkins")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "David S. Pumpkins and his dancing skeleton friends"
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var secondImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DavidSPumpkins")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "David S. Pumpkins and his dancing skeleton friends"
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        view.backgroundColor = .white
        // adding drag and drop interactions to the appropriate elements
        let dragInteraction = UIDragInteraction(delegate: self)
        davidSPumpkinsPhoto.addInteraction(dragInteraction)
        dragInteraction.isEnabled = true

        // adding a separate drag interaction for the 2nd imageView that we want to be draggable
        let secondDrag = UIDragInteraction(delegate: self)
        secondImage.addInteraction(secondDrag)
        secondDrag.isEnabled = true
        // note that for some elements like imageViews, the isEnabled property on the dragInteraction needs to be set to true as show below

        let dropInteraction = UIDropInteraction(delegate: self)
        secondView.addInteraction(dropInteraction)
        secondView.isUserInteractionEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        secondView.layer.borderColor = UIColor.gray.cgColor
        secondView.layer.borderWidth = 2.0
    }

    func buildView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 2.0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16.0).isActive = true
        containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        containerView.addSubview(davidSPumpkinsPhoto)
        davidSPumpkinsPhoto.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16).isActive = true
        davidSPumpkinsPhoto.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2).isActive = true
        davidSPumpkinsPhoto.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2).isActive = true
        davidSPumpkinsPhoto.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true

        containerView.addSubview(secondImage)
        secondImage.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16).isActive = true
        secondImage.widthAnchor.constraint(equalTo: davidSPumpkinsPhoto.widthAnchor).isActive = true
        secondImage.heightAnchor.constraint(equalTo: davidSPumpkinsPhoto.heightAnchor).isActive = true
        secondImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true

        containerView.addSubview(secondView)
        secondView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        secondView.topAnchor.constraint(equalToSystemSpacingBelow: davidSPumpkinsPhoto.bottomAnchor, multiplier: 3.0).isActive = true
        secondView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true


        //calling the method that adds the UIAccessibilityLocationDescriptor to the draggable element
        secondImage.makeAccessibleElement(with: "Drag Image")
        davidSPumpkinsPhoto.makeAccessibleElement(with: "Drag Photo")
        //this is called on each draggable imageView, and a different name is passed in the param for each - this is so each draggable item can have it's own a11yLocationDescriptor

        //calling the method that adds the UIAccessibilityLocationDescriptor to the element that accepts drops
        secondView.makeAccessible()
    }

    // MARK: Drag Interaction
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        scrollView.isScrollEnabled = false
        let touchedPoint = session.location(in: self.view)

        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
            let touchedImage = touchedImageView.image
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchedImageView
            return [dragItem]
        }
        return []
    }

    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }


    // MARK: Drop Interaction
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
        //return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        scrollView.isScrollEnabled = false
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)

        let operation: UIDropOperation

       // if davidSPumpkinsPhoto.frame.contains(dropLocation) || secondImage.frame.contains(dropLocation) {
        if secondView.frame.contains(dropLocation) {
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            operation = .cancel
        }

        return UIDropProposal(operation: operation)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//        session.items.forEach { $0.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, error) in
//            guard let draggedImage = obj as? UIImage else { return }
//
//            let imageView = UIImageView(image: draggedImage)
//            self.secondView.addSubview(imageView)
//            })
//        }

        let dropLocation = session.location(in: self.view)
        updateLayers(forDropLocation: dropLocation)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        let dropLocation = session.location(in: self.view)
        updateLayers(forDropLocation: dropLocation)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        let dropLocation = session.location(in: self.view)
        updateLayers(forDropLocation: dropLocation)
        scrollView.isScrollEnabled = true
    }

    func updateLayers(forDropLocation dropLocation: CGPoint) {
        if secondView.frame.contains(dropLocation) {
            secondView.layer.borderWidth = 5.0
            secondView.layer.borderColor = UIColor.green.cgColor
            davidSPumpkinsPhoto.layer.borderWidth = 0.0
            secondImage.layer.borderWidth = 0.0
        } else {
            davidSPumpkinsPhoto.layer.borderWidth = 0.0
            secondImage.layer.borderWidth = 0.0
        }
    }
}

// MARK: add UIAccessibilityLocationDescriptors to the item that is to dragged
extension UIImageView {
    func makeAccessibleElement(with dragDescriptor: String) {
        let a11yElementImage = UIAccessibilityElement(accessibilityContainer: self)
        a11yElementImage.accessibilityFrameInContainerSpace = self.frame

        if #available(iOS 11.0, *) {
            let dragPoint = CGPoint(x: self.frame.midX, y: self.frame.midY)
            let descriptor = UIAccessibilityLocationDescriptor(name: dragDescriptor, point: dragPoint, in: self)
            a11yElementImage.accessibilityDragSourceDescriptors = [descriptor]
        } else {
            // Fallback on earlier versions
            print("must be using at least iOS 11 to use the UIDragInteraction and UIDropInteraction APIs")
        }
    }
}

// MARK: add UIAccessibilityLocationDescriptors to the item that is to be a drop location
extension UIView {
    func makeAccessible() {
        let a11yElementView = UIAccessibilityElement(accessibilityContainer: self)
        a11yElementView.accessibilityFrameInContainerSpace = self.frame

        if #available(iOS 11.0, *) {
            let dropDescriptor = UIAccessibilityLocationDescriptor(name: "Drop View", view: self)

            self.accessibilityDropPointDescriptors = [dropDescriptor]

        } else {
            // Fallback on earlier versions
        }
    }
}
