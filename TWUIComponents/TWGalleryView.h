//
//  TWUIComponents
//

#import <UIKit/UIKit.h>


@interface TWGalleryView : UIScrollView

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, copy) void (^galleryDidScrollToIndexBlock)(NSInteger index);
@property (nonatomic, assign, readonly) NSInteger currentIndex;


- (instancetype)init __unavailable;

@end
