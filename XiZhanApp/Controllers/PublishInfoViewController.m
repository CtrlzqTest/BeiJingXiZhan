//
//  PublishInfoViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PublishInfoViewController.h"
#import "ZQPhotoViewCell.h"

static NSString *photoColCellId = @"photoColCellId";
@interface PublishInfoViewController ()<UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imaPic;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *titleTef;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation PublishInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
}

- (void)setupViews {
    
    self.contentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.layer.cornerRadius = 5;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.layer.borderWidth = 0.7;
//    self.collectionView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZQPhotoViewCell" bundle:nil] forCellWithReuseIdentifier:photoColCellId];
    
}

// 消息发布
- (IBAction)publishAction:(id)sender {
    
    
    
}

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册中选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            imaPic.delegate = self;
            [self presentViewController:imaPic animated:YES completion:nil];
        }
    }else if (buttonIndex == 1) {
        
//        [self loadImgDataAndShowAllGroup];
    }
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-64) /4 ,([UIScreen mainScreen].bounds.size.width-64) /4);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 8, 20, 8);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoColCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setBigImgViewWithImage:[UIImage imageNamed:@"add"]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self showActionSheet];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
