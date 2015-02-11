//
//  AOAppsView.m
//  AOAppsIfo
//
//  Created by Alekseenko Oleg on 25.12.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import "AOAppsView.h"
#import <VZPolicCollectionView.h>
#import <VZAppCollectionCell.h>
#import <AOInfoNetManager.h>
#import <UIView+CLPLoading.h>
#import <AOAppModel.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <AOFile.h>

static NSString * const AOAppViewUserDefaultsKey = @"AOAppViewUserDefaultsKey";
static float const AOAppViewTitleHeigth = 50;

@interface AOAppsView () <VZPolicCollectionViewDelegate>
@property (nonatomic, strong) VZPolicCollectionView *collectionView;
@property (nonatomic, strong) NSArray *content;
@end


@implementation AOAppsView

+ (instancetype)appsViewWithWidth:(CGFloat)width {
    AOAppsView *view = [[AOAppsView alloc] initWithFrame:CGRectMake(0, 0, width, VZAppCollectionCellSize.height + AOAppViewTitleHeigth)];
    [view loadData];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = ({
        CGRect frame = self.frame;
        frame.size.height = VZAppCollectionCellSize.height + AOAppViewTitleHeigth;
        frame;
    });
    
    [self setup];
    [self loadData];
}

#pragma mark - Setup -

- (void)setup {
    self.noDataErrorText = @"Ничего не загрузилось";
    [self setupTitleLabel];
    [self setupCollectionView];
    [self loadData];
}

- (void)setupCollectionView {
    if (!self.collectionView) {
        self.collectionView = [[VZPolicCollectionView alloc] initWithFrame:CGRectMake(0, AOAppViewTitleHeigth, self.frame.size.width, self.frame.size.height - AOAppViewTitleHeigth)];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.collectionView.centerContent = YES;
        self.collectionView.delegate = self;
        self.collectionView.sectionWidth = VZAppCollectionCellSize.width;
        [self addSubview:self.collectionView];
    }
}

- (void)setupTitleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, AOAppViewTitleHeigth)];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLabel.textColor = [UIColor colorWithRed:97.0/255.0 green:172.0/255.0 blue:243.0/255.0 alpha:1.0];
        _titleLabel.text = @"Наши приложения";
        [self addSubview:_titleLabel];
    }
}



#pragma mark - Actions -

- (void)loadData {
    
    self.content = [self loadContent];
    if (self.content.count > 0) {
        [self.collectionView reloadData];
    } else {
        [self clp_showLoading];
    }

    __weak typeof(self) weakSelf = self;
    [[AOInfoNetManager sharedManager] getOurAppsWithSuccess:^(NSArray *objects) {
        [weakSelf saveContent:objects];
        weakSelf.content = [weakSelf loadContent];
        if (weakSelf.content.count > 0) {
            [weakSelf clp_hideAll];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf clp_showError:self.noDataErrorText retryBlock:NULL];
        }
    } fail:^(NSError *error) {
        if (weakSelf.content.count == 0) {
            [weakSelf clp_showError:[error localizedDescription] retryBlock:NULL];
        }
    }];
}


#pragma mark - Helpers -

- (NSArray *)loadContent {

    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:AOAppViewUserDefaultsKey];
    NSArray *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return result;
}

- (void)saveContent:(NSArray *)content {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:content];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:AOAppViewUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - VZPolicCollectionDelegate -

- (VZPolicCollectionCell *)policCollectionView:(VZPolicCollectionView *)view cellAtIndex:(NSInteger)index {
    
    VZAppCollectionCell *cell = [view dequeCellWithIdentifier:VZAppCollectionCellIdentifier];
    if (!cell) {
        cell = [[VZAppCollectionCell alloc] initWithDefaultSizes];
    }
    AOAppModel *model = self.content[index];
    cell.textLabel.text = model.text;
    NSURL *url = [NSURL URLWithString:model.icon.url];
    [cell.imageView setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)policCollectionView:(VZPolicCollectionView *)collectionView didTappedCell:(VZPolicCollectionCell *)cell atIndex:(NSInteger)index {
    
    AOAppModel *model = self.content[index];
    NSURL *url = [NSURL URLWithString:model.redirectURL];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        url = [NSURL URLWithString:model.url];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

- (NSInteger)numberOfSectionInPolicCollectionView:(VZPolicCollectionView *)view {
    return self.content.count;
}


@end
