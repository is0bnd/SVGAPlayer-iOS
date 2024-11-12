//
//  TestViewController.h
//  SVGAPlayer
//
//  Created by 王帅成 on 2024/11/7.
//  Copyright © 2024 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController

@end

@interface FPSLabel : UILabel
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@end

@implementation FPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDisplayLink];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrameRate:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateFrameRate:(CADisplayLink *)displayLink {
    if (self.lastTimestamp == 0) {
        self.lastTimestamp = displayLink.timestamp;
        return;
    }

    self.frameCount += 1;
    NSTimeInterval elapsed = displayLink.timestamp - self.lastTimestamp;

    if (elapsed >= 1.0) {
        CGFloat fps = self.frameCount / elapsed;
        self.text = [NSString stringWithFormat:@"%.0f", fps];
        
        self.lastTimestamp = displayLink.timestamp;
        self.frameCount = 0;
    }
}

- (void)dealloc {
    [self.displayLink invalidate];
}

@end
NS_ASSUME_NONNULL_END
