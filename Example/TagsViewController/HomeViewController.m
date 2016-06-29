//
//  HomeViewController.m
//  Example
//
//  Created by Mingenesis on 16/6/29.
//
//

#import "HomeViewController.h"
#import "MKTagsViewController.h"
#import "TopicViewController.h"

@interface HomeViewController ()<MKTagsViewControllerDelegate>

@property (nonatomic, weak) MKTagsViewController *tagsViewController;
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
    
    self.tagsViewController.delegate = self;
    self.tagsViewController.viewControllers = @[vc1, vc2, vc3];
    
    [self updateTagButtons];
}

- (void)updateTagButtons {
    for (UIButton *button in self.tagButtons) {
        button.selected = self.tagsViewController.viewControllers[button.tag] == self.tagsViewController.selectedViewController;
    }
}

- (IBAction)tagButtonDidClick:(UIButton *)sender {
    UIViewController *vc = self.tagsViewController.viewControllers[sender.tag];
    
    self.tagsViewController.selectedViewController = vc;
    
    [self updateTagButtons];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Body"]) {
        self.tagsViewController = segue.destinationViewController;
    }
}

#pragma mark - MKTagsViewControllerDelegate

- (void)tagsViewController:(MKTagsViewController *)tagsViewController didSelectViewController:(UIViewController *)viewController {
    [self updateTagButtons];
}

@end
