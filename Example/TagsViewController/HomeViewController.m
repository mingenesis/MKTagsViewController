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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLineCenterConstraint;
@property (weak, nonatomic) IBOutlet UIView *tagBar;
@property (nonatomic) CGFloat tagLineCenter;

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
    
    [self updateTagLine:NO];
    [self.interactiveGestureRecognizer addTarget:self action:@selector(handleInteractive:)];
}

- (void)updateTagLine:(BOOL)animated {
    NSInteger idx = [self.viewControllers indexOfObject:self.selectedViewController];
    CGFloat count = self.viewControllers.count;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat center = 0.5 * screenWidth * (-1 + (2 * idx + 1) / count);
    
    self.tagLineCenterConstraint.constant = center;
    
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
            [self.tagBar layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)tagButtonDidClick:(UIButton *)sender {
    UIViewController *vc = self.viewControllers[sender.tag];
    
    self.selectedViewController = vc;
    
    [self updateTagLine:YES];
}

- (void)handleInteractive:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [panGR translationInView:panGR.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.tagLineCenter = self.tagLineCenterConstraint.constant;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.tagLineCenterConstraint.constant = self.tagLineCenter - 0.2 * translation.x / self.viewControllers.count;
    }
    else {
        [self updateTagLine:YES];
    }
}

#pragma mark - MKTagsViewControllerDelegate

- (void)tagsViewController:(MKTagsViewController *)tagsViewController didSelectViewController:(UIViewController *)viewController {
    [self updateTagLine:YES];
}

@end
