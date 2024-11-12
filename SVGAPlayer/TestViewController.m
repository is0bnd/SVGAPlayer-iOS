//
//  TestViewController.m
//  SVGAPlayer
//
//  Created by 王帅成 on 2024/11/7.
//  Copyright © 2024 UED Center. All rights reserved.
//

#import "TestViewController.h"
#import "SVGA.h"

@interface TestCell : UITableViewCell

@property (nonatomic, assign) NSString *path;
@property (nonatomic, assign) CGSize playerSize;
@property (nonatomic, strong) SVGAPlayer *player;

@end


@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    [self.contentView addSubview:self.player];
}

- (void)setPlayerSize:(CGSize)playerSize {
    [self.player stopAnimation];
    self.player.videoItem = nil;
    self.player.frame = CGRectMake(0, 0, playerSize.width, playerSize.height);
    SVGAParser *parser = [SVGAParser new];
    parser.enabledMemoryCache = NO;
    SVGACapInsets insets = SVGACapInsetsMake(54, 46);
    __weak typeof(self) weakself = self;
    [parser parseWithFilePath:self.path size:playerSize capInsets:insets completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        weakself.player.videoItem = videoItem;
        [weakself.player startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (SVGAPlayer *)player {
    if (!_player) {
        _player = [SVGAPlayer new];
    }
    return _player;
}

- (NSString *)path {
    return [[NSBundle mainBundle] pathForResource:@"bubble" ofType:@"svga"];
}

@end

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *dataArray;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i = 0; i < 20; i++) {
        CGSize size = CGSizeMake(arc4random_uniform(100) + 100, arc4random_uniform(100) + 100);
        [self.dataArray addObject:[NSValue valueWithCGSize:size]];
    }
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    FPSLabel *label = [[FPSLabel alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.playerSize = self.dataArray[indexPath.row].CGSizeValue;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.row].CGSizeValue.height;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor blackColor];
        [_tableView registerClass:[TestCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray<NSValue *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
