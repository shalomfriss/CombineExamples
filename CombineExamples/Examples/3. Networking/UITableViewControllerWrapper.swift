//
//  UITableViewControllerWrapper.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import SwiftUI
import Combine

final class UITableViewControllerWrapper: UIViewControllerRepresentable {
    var anyPublisher:AnyPublisher<[Post], Error>?
    var anyCancellable:AnyCancellable?
    var service:URLSessionExtensions = URLSessionExtensions()
    
    var posts:[Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.vc?.tableView.reloadData()
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UITableViewController {
        
        anyCancellable = service.getPosts().catch {
            _ in Just([Post]())
        }.assign(to: \.posts, on: self)
        
        let tvc = UITableViewController()
        tvc.tableView.delegate = context.coordinator
        tvc.tableView.dataSource = context.coordinator
        
        tvc.tableView.rowHeight = UITableView.automaticDimension
        tvc.tableView.estimatedRowHeight = UITableView.automaticDimension
        tvc.tableView.separatorStyle = .none
        tvc.tableView.allowsSelection = false
        tvc.tableView.allowsSelectionDuringEditing = true
        tvc.tableView.allowsMultipleSelectionDuringEditing = true

        self.vc = tvc
        return tvc
    }
    
    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        uiViewController.tableView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    typealias UIViewControllerType = UITableViewController

    var vc: UITableViewController?
    
}

// MARK: - Coordinator
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

        // MARK: Properties and initializer
        private let parent: UITableViewControllerWrapper

        init(_ parent: UITableViewControllerWrapper) {
            self.parent = parent
        }

        // MARK: UITableViewDelegate and DataSource methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.posts.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return createPostCell(indexPath, tableView)
        }

        // MARK: - Private helpers
        fileprivate func createPostCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
            //let comment = parent.comments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DebugCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DebugCell")

            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.lineBreakMode = .byCharWrapping
            cell.textLabel!.text = parent.posts[indexPath.row].title
            return cell
        }
        
        
        //        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //            UITableView.automaticDimension
        //        }

        //        var cellHeights = [IndexPath: CGFloat]()

        //        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //            cellHeights[indexPath] = cell.frame.size.height
        //        }

        //        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //            return cellHeights[indexPath] ?? UITableView.automaticDimension
        //        }
    }
