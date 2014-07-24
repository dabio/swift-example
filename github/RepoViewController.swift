//
//  RepoViewController.swift
//  github
//
//  Created by Danilo Braband on 23.07.14.
//  Copyright (c) 2014 parku Verwaltung GmbH & Co. KG. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

  @IBOutlet weak var descriptionLabel: UILabel!

  var repo: Repository = Repository(name: "", watchers: 0, description: "")

  // MARK: - Controller Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = self.repo.name
    self.descriptionLabel.text = self.repo.description
    self.descriptionLabel.sizeToFit()
  }

}
