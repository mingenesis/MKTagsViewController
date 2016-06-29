//
//  HomeViewController.m
//  Example
//
//  Created by Mingenesis on 16/6/29.
//
//

#import "HomeViewController.h"
#import "TopicViewController.h"

@interface HomeViewController ()<MKTagsViewControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tagButtons;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TopicViewController *vc1 = [[TopicViewController alloc] init];
    vc1.title = @"vc1";
    
    TopicViewController *vc2 = [[TopicViewController alloc] init];
    vc2.title = @"vc2";
    
    TopicViewController *vc3 = [[TopicViewController alloc] init];
    vc3.title = @"vc3";
    
    self.delegate = self;
    self.viewControllers = @[vc1, vc2, vc3];
    
    [self updateTagButtons];
}

- (void)updateTagButtons {
    for (UIButton *button in self.tagButtons) {
        button.selected = self.viewControllers[button.tag] == self.selectedViewController;
    }
}

- (IBAction)tagButtonDidClick:(UIButton *)sender {
    UIViewController *vc = self.viewControllers[sender.tag];
    
    self.selectedViewController = vc;
    
    [self updateTagButtons];
}


#pragma mark - MKTagsViewControllerDelegate

- (void)tagsViewController:(MKTagsViewController *)tagsViewController didSelectViewController:(UIViewController *)viewController {
    [self updateTagButtons];
}

@end
