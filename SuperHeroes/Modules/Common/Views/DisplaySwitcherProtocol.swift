//
//  DisplaySwitcherProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 13/10/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit
import DisplaySwitcher

class DisplaySwitcherComponent {

    var animationDuration: TimeInterval = 0.3
    var isTransitionAvailable:Bool = true
    private let modeButton: SwitchLayoutButton = {
        let button = SwitchLayoutButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button;
    }()
    var listModeButton: SwitchLayoutButton {
        return modeButton
    }
    var layoutState: LayoutState = .list
    let listLayout: DisplaySwitchLayout
    let gridLayout: DisplaySwitchLayout

    required init(listCellHeight: CGFloat, gridCellHeight: CGFloat, animationDuration: TimeInterval) {
        listLayout = DisplaySwitchLayout(staticCellHeight: listCellHeight, nextLayoutStaticCellHeight: gridCellHeight, layoutState: .list)
        gridLayout = DisplaySwitchLayout(staticCellHeight: gridCellHeight, nextLayoutStaticCellHeight: listCellHeight, layoutState: .grid)
        self.animationDuration = animationDuration
    }
}

protocol HasDisplaySwitcherComponent {
    var component: DisplaySwitcherComponent { get set }
}

protocol DisplaySwitcherProtocol: HasDisplaySwitcherComponent {

    var listView: UIScrollView? { get }
    func toggleListMode()
    func transitionLayout(transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout
}

extension DisplaySwitcherProtocol {

    var listModeButton: SwitchLayoutButton {
        return component.listModeButton
    }
    var layoutState: LayoutState {
        return component.layoutState
    }
    func toggleListMode() {

        if !component.isTransitionAvailable {
            return
        }
        guard let collectionView = listView as? UICollectionView else {
            return
        }

        let transitionManager: TransitionManager
        if component.layoutState == .list {
            component.layoutState = .grid
            transitionManager = TransitionManager(duration: component.animationDuration, collectionView: collectionView, destinationLayout: component.gridLayout, layoutState: component.layoutState)
        } else {
            component.layoutState = .list
            transitionManager = TransitionManager(duration: component.animationDuration, collectionView: collectionView, destinationLayout: component.listLayout, layoutState: component.layoutState)
        }
        transitionManager.startInteractiveTransition()
        component.listModeButton.isSelected = component.layoutState == .list
        component.listModeButton.animationDuration = component.animationDuration
    }

    public func transitionLayout(transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
}

//MARK: Override Scroll View Dragging Methods
extension DisplaySwitcherProtocol {

    func beginScrolling() {
        //avoid layout transition while scrolling
        component.isTransitionAvailable = false
    }

    func endScrolling() {
        //enable layout transition when scrolling ends
        component.isTransitionAvailable = true
    }
}
