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
    
    [self updateTagLineForBarWidth:0 animated:NO];
    [self.interactiveGestureRecognizer addTarget:self action:@selector(handleInteractive:)];
}

- (void)updateTagLineForBarWidth:(CGFloat)width animated:(BOOL)animated  {
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    NSInteger idx = [self.viewControllers indexOfObject:self.selectedViewController];
    CGFloat count = self.viewControllers.count;
    CGFloat center = 0.5 * width * (-1 + (2 * idx + 1) / count);
    
    self.tagLineCenterConstraint.constant = center;
    
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
            [self.tagBar layoutIfNeeded];
        } completion:nil];
    }
}

- (CGFloat)tagBarWidthForSize:(CGSize)size {
    return MIN(size.width, size.height);
}

- (IBAction)tagButtonDidClick:(UIButton *)sender {
    UIViewController *vc = self.viewControllers[sender.tag];
    
    self.selectedViewController = vc;
    
    [self updateTagLineForBarWidth:0 animated:YES];
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
        [self updateTagLineForBarWidth:0 animated:YES];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self updateTagLineForBarWidth:size.width animated:NO];
}

#pragma mark - MKTagsViewControllerDelegate

- (void)tagsViewController:(MKTagsViewController *)tagsViewController didSelectViewController:(UIViewController *)viewController {
    [self updateTagLineForBarWidth:0 animated:YES];
}

@end
