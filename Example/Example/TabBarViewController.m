//
//  TabBarViewController.m
//  Example
//
//  Created by Mingenesis on 16/6/29.
//
//

#import "TabBarViewController.h"
#import "TopicViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)loadView {
    [super loadView];
    
    TopicViewController *vc1 = [[TopicViewController alloc] init];
    vc1.title = @"tb1";
    
    TopicViewController *vc2 = [[TopicViewController alloc] init];
    vc2.title = @"tb2";
    
    TopicViewController *vc3 = [[TopicViewController alloc] init];
    vc3.title = @"tb3";
    
    self.viewControllers = @[vc1, vc2, vc3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
