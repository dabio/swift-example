//
//  ReposTableViewController.swift
//  github
//
//  Created by Danilo Braband on 22.07.14.
//  Copyright (c) 2014 parku Verwaltung GmbH & Co. KG. All rights reserved.
//

import UIKit

struct Repository {
  let name: String
  let watchers: Int
  let description: String
}


class ReposTableViewController: UITableViewController {

  var repos: [Repository] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    self.refreshControl = UIRefreshControl()
    self.refreshControl.addTarget(self, action: "loadRepos", forControlEvents: UIControlEvents.ValueChanged)
  }


  // MARK: - Actions

  func loadRepos() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true

    let url: NSURL = NSURL(string: "https://api.github.com/users/github/repos")
    NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {
      (data: NSData!, response: NSURLResponse!, error: NSError!) in

      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      self.refreshControl.endRefreshing()

      self.parseJSON(data)
      self.showRepos()
    }).resume()

  }

  func parseJSON(data: NSData) {
    let json: [NSDictionary] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as Array<NSDictionary>

    self.repos = []
    for jsonRepo in json {

      let repo = Repository(
        name: jsonRepo["name"] as String!,
        watchers: jsonRepo["watchers_count"] as Int!,
        description: jsonRepo["description"] as String!
      )

      self.repos.append(repo)
    }

  }

  func showRepos() {
    self.tableView.reloadData()
  }


  // MARK: - UITableViewDataSource

  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return self.repos.count
  }

  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let cell = tableView.dequeueReusableCellWithIdentifier("reposCell", forIndexPath: indexPath) as UITableViewCell

    cell.textLabel.text = self.repos[indexPath.row].name
    cell.detailTextLabel.text = "\(self.repos[indexPath.row].watchers)"

    return cell
  }


  // MARK: -Segueing

  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {

    if segue.identifier == "detailRepoSegue" {
      let vc: RepoViewController = segue.destinationViewController as RepoViewController
      vc.repo = self.repos[self.tableView.indexPathForSelectedRow().row]
    }
  }


}
