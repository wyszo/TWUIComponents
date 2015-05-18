//
//  TWUIComponents
//

#import <UIKit/UIKit.h>


/**
 TODO: Gallery view should not be a scrollView (as using a scrollView here is just an implementation detail). It should be a UIView with scrollView added later programatically.
 */

@interface TWGalleryView : UIScrollView

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, copy) void (^galleryDidScrollToIndexBlock)(NSInteger index);
@property (nonatomic, assign, readonly) NSInteger currentIndex;


- (instancetype)init __unavailable;

@end
