//
//  Wireframe.swift
//  Lectures
//
//  Created by Александр Сибирцев on 02.05.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class Wireframe {
    static func promptOKAlertFor(src: UIViewController,
                                 title: String?,
                                 message: String?) -> Driver<()> {
        return promptAlertFor(src: src,
                              title: title,
                              message: message,
                              cancelAction: "OK",
                              actions: [])
            .map { _ in }
    }

    static func promptSimpleActionSheetFor<Action: CustomStringConvertible>(src: UIViewController,
                                                                            cancelAction: Action,
                                                                            actions: [Action]) -> Driver<Action> {
        return promptFor(src, nil, nil, cancelAction, actions, .actionSheet)
    }

    private static func promptAlertFor<Action: CustomStringConvertible>(src: UIViewController,
                                                                        title: String?,
                                                                        message: String?,
                                                                        cancelAction: Action,
                                                                        actions: [Action]) -> Driver<Action> {
        return promptFor(src, title, message, cancelAction, actions, .alert)
    }

    private static func promptFor<Action: CustomStringConvertible>(_ src: UIViewController,
                                                                   _ title: String?,
                                                                   _ message: String?,
                                                                   _ cancelAction: Action,
                                                                   _ actions: [Action],
                                                                   _ style: UIAlertController.Style
    ) -> Driver<Action> {
        return ControlEvent(events: Observable.create { observer in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: style)
            alertController.addAction(UIAlertAction(title: cancelAction.description,
                                                    style: .cancel) { _ in
                    observer.on(.next(cancelAction))
                    observer.on(.completed)
            })

            for action in actions {
                alertController.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                    observer.on(.completed)
                })
            }

            src.present(alertController, animated: true, completion: nil)

            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        }).asDriver()
    }
}

