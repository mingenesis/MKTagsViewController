//
//  MainViewController.m
//  Example
//
//  Created by Mingenesis on 16/6/27.
//
//

#import "MainViewController.h"
#import "TopicViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    
    TopicViewController *vc1 = [[TopicViewController alloc] init];
    vc1.title = @"vc1";
    
    TopicViewController *vc2 = [[TopicViewController alloc] init];
    vc2.title = @"vc2";
    
    TopicViewController *vc3 = [[TopicViewController alloc] init];
    vc3.title = @"vc3";
    
    self.viewControllers = @[vc1, vc2, vc3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
