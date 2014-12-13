//
//  SIViewController.m
//  SIFontManager
//
//  Created by Xiao ChenYu on 12/13/2014.
//  Copyright (c) 2014 Xiao ChenYu. All rights reserved.
//

#import "SIViewController.h"

@interface SIViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *fontStyleCell;

@end

@implementation SIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.fontStyleCell]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.fontStyleCell]) {
        NSLog(@"hello");
    }
}

@end
