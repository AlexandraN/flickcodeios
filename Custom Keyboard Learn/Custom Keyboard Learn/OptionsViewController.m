//
//  OptionsViewController.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 12/12/12.
//  Copyright (c) 2012 fandaliu. All rights reserved.
//

#import "OptionsViewController.h"
#import "ContentViewController.h"
#import "CreateSMSTextViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface OptionsViewController ()


@end

@implementation OptionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    //    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([MFMessageComposeViewController canSendText]) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *cellText =  @"Just Text";
    int row = indexPath.row;
    
    if ([MFMessageComposeViewController canSendText]) {
        switch (row) {
            case 0: {
                cellText =  @"Just Text";
                break;
            }
            case 1: {
                cellText =  @"SMS";
                break;
            }
            default:
                break;
        }
    } else {
        switch (row) {
            case 0: {
                cellText =  @"Just Text";
                break;
            }
            default:
                break;
        }
    }
    
    
    cell.textLabel.text = cellText;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ([MFMessageComposeViewController canSendText]) {
        switch (row) {
            case 0: {
                [self pushJustTextOption];
                break;
            }
            case 1: {
                [self pushCreateSmsOption];
                break;
            }
            default:
                break;
        }
    } else {
        switch (row) {
            case 0: {
                [self pushJustTextOption];
                break;
            }
            default:
                break;
        }
    }
    
}

- (void) pushCreateSmsOption {
    CreateSMSTextViewController *smsCreationViewController = [[CreateSMSTextViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    smsCreationViewController.title = @"Create SMS";
    [self.navigationController pushViewController:smsCreationViewController animated:YES];
}

- (void) pushJustTextOption {
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    contentViewController.title = @"Just Text";
    [self.navigationController pushViewController:contentViewController animated:YES];
}

@end
