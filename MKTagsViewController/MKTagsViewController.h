//
//  MKTagsViewController.h
//  
//
//  Created by Mingenesis on 16/6/24.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKTagsViewControllerDelegate;

@interface MKTagsViewController : UIViewController

@property (nullable, nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;
@property (nullable, nonatomic, weak) UIViewController *selectedViewController;
@property (nullable, nonatomic, readonly) UIGestureRecognizer *interactiveGestureRecognizer;

@property (nullable, nonatomic, weak) id<MKTagsViewControllerDelegate> delegate;

@end

@protocol MKTagsViewControllerDelegate <NSObject>

@optional
- (void)tagsViewController:(MKTagsViewController *)tagsViewController didSelectViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END