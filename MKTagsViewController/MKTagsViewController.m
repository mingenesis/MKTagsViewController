//
//  MKTagsViewController.m
//  
//
//  Created by Mingenesis on 16/6/24.
//
//

#import "MKTagsViewController.h"
#import "MKTagsPanGestureRecognizer.h"

@interface MKTagsViewController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, weak) UIViewController *transitioningViewController;
@property (nonatomic) NSInteger transDirection;

@end

@implementation MKTagsViewController

- (void)loadView {
    [super loadView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.clipsToBounds = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    
    NSDictionary *vs = NSDictionaryOfVariableBindings(contentView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:vs]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:vs]];
    
    MKTagsPanGestureRecognizer *interactiveGR = [[MKTagsPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleInteractiveGR:)];
    [contentView addGestureRecognizer:interactiveGR];
    
    _contentView = contentView;
    _interactiveGestureRecognizer = interactiveGR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self transitionFromViewController:nil toViewController:self.selectedViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleResignActiveNotification:(NSNotification *)noti {
    self.interactiveGestureRecognizer.enabled = NO;
    self.interactiveGestureRecognizer.enabled = YES;
}

- (void)handleInteractiveGR:(UIPanGestureRecognizer *)gestureRecognizer {
    NSLog(@"handleInteractiveGR:%@", @(gestureRecognizer.state));
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.transDirection = translation.x > 0 ? 1 : -1;
        
        [self.selectedViewController beginAppearanceTransition:NO animated:YES];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if ((translation.x >= 0 && self.transDirection == -1) || (translation.x <= 0 && self.transDirection == 1)) {
            if (self.transitioningViewController) {
                [self.transitioningViewController beginAppearanceTransition:NO animated:NO];
                [self.transitioningViewController.view removeFromSuperview];
                [self.transitioningViewController endAppearanceTransition];
                
                self.transitioningViewController = nil;
            }
        }
        
        if (!self.transitioningViewController) {
            self.transDirection = translation.x > 0 ? 1 : -1;
            NSUInteger selectedIndex = [self.viewControllers indexOfObject:self.selectedViewController];
            NSInteger transIndex = selectedIndex - self.transDirection;
            
            if (0 <= transIndex && transIndex < self.viewControllers.count) {
                self.transitioningViewController = self.viewControllers[transIndex];
                
                [self.transitioningViewController beginAppearanceTransition:YES animated:YES];
                
                self.transitioningViewController.view.frame = self.contentView.bounds;
                self.transitioningViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [self.contentView addSubview:self.transitioningViewController.view];
            }
        }
        
        CGRect selectedFrame = self.contentView.bounds;
        CGFloat originX = 0.5 * translation.x * selectedFrame.size.width / (selectedFrame.size.width + self.transDirection * translation.x);
        
        if (self.transitioningViewController) {
            CGRect transFrame = self.contentView.bounds;
            
            CGFloat origX = self.transDirection * translation.x - selectedFrame.size.width;
            if (origX > 0) {
                selectedFrame.origin.x = self.transDirection * (selectedFrame.size.width + 0.5 * origX * selectedFrame.size.width / (selectedFrame.size.width + origX));
            } else {
                selectedFrame.origin.x = translation.x;
            }
            transFrame.origin.x = selectedFrame.origin.x - self.transDirection * (transFrame.size.width + 10);
            
            self.transitioningViewController.view.frame = transFrame;
        } else {
            selectedFrame.origin.x = originX;
        }
        
        self.selectedViewController.view.frame = selectedFrame;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect selectedFrame = self.contentView.bounds;
        CGRect transFrame = self.contentView.bounds;
        UIViewController *transitioningVC = self.transitioningViewController;
        UIViewController *selectedVC = self.selectedViewController;
        
        selectedFrame.origin.x = self.transDirection * (selectedFrame.size.width + 10);
        _selectedViewController = transitioningVC;
        
        self.transitioningViewController = nil;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            selectedVC.view.frame = selectedFrame;
            transitioningVC.view.frame = transFrame;
        } completion:^(BOOL finished) {
            [selectedVC.view removeFromSuperview];
            
            [selectedVC endAppearanceTransition];
            [transitioningVC endAppearanceTransition];
            
            [self.selectedViewController didMoveToParentViewController:self];
        }];
    }
    else {
        CGRect selectedFrame = self.contentView.bounds;
        CGRect transFrame = self.contentView.bounds;
        UIViewController *transitioningVC = self.transitioningViewController;
        UIViewController *selectedVC = self.selectedViewController;
        
        transFrame.origin.x = - self.transDirection * (transFrame.size.width + 10);
        
        self.transitioningViewController = nil;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            selectedVC.view.frame = selectedFrame;
            transitioningVC.view.frame = transFrame;
            
            [selectedVC beginAppearanceTransition:YES animated:YES];
            [transitioningVC beginAppearanceTransition:NO animated:YES];
        } completion:^(BOOL finished) {
            [transitioningVC.view removeFromSuperview];
                
            [selectedVC endAppearanceTransition];
            [transitioningVC endAppearanceTransition];
            
            [self.selectedViewController didMoveToParentViewController:self];
        }];
    }
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    if (fromViewController) {
        [fromViewController willMoveToParentViewController:nil];
        [fromViewController.view removeFromSuperview];
    }
    
    if (toViewController) {
        toViewController.view.frame = self.contentView.bounds;
        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
    }
}

#pragma mark - Setter / Getter

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    UIViewController *fromSVC = self.selectedViewController;
    
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    
    _viewControllers = viewControllers;
    
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
    
    if (fromSVC && [viewControllers containsObject:fromSVC]) {
        self.selectedViewController = fromSVC;
    }
    else {
        self.selectedViewController = viewControllers.firstObject;
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (selectedViewController) {
        if (![self.viewControllers containsObject:selectedViewController]) {
            return;
        }
        
        if (selectedViewController == _selectedViewController) {
            return;
        }
    }
    
    UIViewController *fromSVC = _selectedViewController;
    _selectedViewController = selectedViewController;
    
    if ([self isViewLoaded]) {
        [self transitionFromViewController:fromSVC toViewController:selectedViewController];
    }
}

@end
