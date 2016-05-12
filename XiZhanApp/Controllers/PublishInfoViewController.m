//
//  PublishInfoViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PublishInfoViewController.h"
#import "ZQPhotoViewCell.h"
#import "MShowAllGroup.h"
#import "MImaLibTool.h"

static NSString *photoColCellId = @"photoColCellId";
@interface PublishInfoViewController ()<UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MShowAllGroupDelegate>
{
    UIImagePickerController *imaPic;
    NSMutableArray *_arrSelected;
    NSMutableArray *_imageArray;
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
    
    _imageArray = [NSMutableArray array];
    
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
        __weak typeof(self) weakSelf = self;
        // 相册选择
        _arrSelected = [NSMutableArray array];
        [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
            if (arrObj && arrObj.count > 0) {
                if ( arrObj.count > 0) {
                    MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:arrObj arrSelected:_arrSelected];
                    svc.delegate = self;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                    if (_arrSelected) {
                        svc.arrSeleted = _arrSelected;
                        svc.mvc.arrSelected = _arrSelected;
                    }
                    svc.maxCout = 6;
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }
            }
        }];
    }
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [_imageArray addObject:image];
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- MShowAllGroupDelegate

-(void)finishSelectImg {
    for (ALAsset *set in _arrSelected) {
        CGImageRef cgImg = [set thumbnail];
        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [_imageArray addObject:image];
    }
    [self.collectionView reloadData];
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
    return _imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoColCellId forIndexPath:indexPath];
    if (indexPath.row == _imageArray.count) {
        [cell setBigImgViewWithImage:[UIImage imageNamed:@"add"]];
    }else {
        [cell setBigImgViewWithImage:_imageArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _imageArray.count) {
        [self showActionSheet];
    }
}

-(void)dealloc {
    _imageArray = nil;
    _arrSelected = nil;
    imaPic = nil;
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
