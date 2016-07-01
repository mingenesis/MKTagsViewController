//
//  TopicViewController.m
//  Example
//
//  Created by Mingenesis on 16/6/27.
//
//

#import "TopicViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

- (void)loadView {
    [super loadView];
    
    if ([self.title isEqualToString:@"vc1"]) {
        self.view.backgroundColor = [UIColor redColor];
    }
    else if ([self.title isEqualToString:@"vc2"]) {
        self.view.backgroundColor = [UIColor blueColor];
    }
    else if ([self.title isEqualToString:@"vc3"]) {
        self.view.backgroundColor = [UIColor greenColor];
    }
    else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ - viewDidLoad:%@", self.title, self.parentViewController);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@ - viewWillAppear:", self.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%@ - viewDidAppear:", self.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ - viewWillDisappear:", self.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"%@ - viewDidDisappear:", self.title);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    NSLog(@"%@ - willMoveToParentViewController:%@", self.title, parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    NSLog(@"%@ - didMoveToParentViewController:%@", self.title, parent);
}

@end
