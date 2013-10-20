//
//  EXQMainCollectionViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQMainCollectionViewController.h"
#import "EXQShareViewController.h"
#import "EXQAppDelegate.h"
#import "EXQCollectionHeaderView.h"
#import <GameKit/GameKit.h>

@interface EXQMainCollectionViewController () <GKTurnBasedEventHandlerDelegate>

@property (nonatomic, retain) NSArray *gameImages;
@property (readonly) EXQAppDelegate *appDelegate;
@property (nonatomic, retain) NSArray *activeMatches;

@end

@implementation EXQMainCollectionViewController

- (EXQAppDelegate*)appDelegate
{
    return (EXQAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (UIViewController*)viewControllerFromStoryboard:(NSString *)vcid
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcid];
    return vc;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row >= self.appDelegate.activeImages.count) {
            UIViewController *vc = [self viewControllerFromStoryboard:@"EXQNewGameController"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{
            }];
        } else {
            // HERE IS WHERE WE GET THE CORRECT STATE AND PUSH TO IT
        }
    } else if (indexPath.section == 1) {
        EXQShareViewController *vc = (EXQShareViewController*)[self viewControllerFromStoryboard:@"EXQShareController"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc setImage:[UIImage imageNamed:[self.gameImages objectAtIndex:indexPath.row]]];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.appDelegate.activeImages.count + 1;
    } else if (section == 1) {
        return self.gameImages.count;
    }
    return 0;
}

- (UICollectionViewCell*)newGameCell:(UICollectionView*)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewGameCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionViewCell*)galleryCell:(UICollectionView*)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GalleryCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *iv = (UIImageView *)[cell viewWithTag:100];
    iv.image = [UIImage imageNamed:[self.gameImages objectAtIndex:indexPath.row]];
    cell.backgroundView = nil; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}


- (UICollectionViewCell*)activeCell:(UICollectionView*)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ActiveCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    
    UIImageView *iv = (UIImageView *)[cell viewWithTag:100];
    iv.image = [UIImage imageNamed:[self.appDelegate.activeImages objectAtIndex:indexPath.row]];
    cell.backgroundView = nil; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        EXQCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXQHeaderView" forIndexPath:indexPath];
        NSString *title = indexPath.section == 0 ? @"Active Plays" : @"Gallery";
        headerView.titleLabel.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row >= self.appDelegate.activeImages.count) {
            return [self newGameCell:collectionView forItemAtIndexPath:indexPath];
        } else {
            return [self activeCell:collectionView forItemAtIndexPath:indexPath];
        }
    } else {
        return [self galleryCell:collectionView forItemAtIndexPath:indexPath];
    }
    

}

- (void) installTurnBasedEventHandler
{
    [GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
}

- (void) loadMatches
{
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (matches)
        {
            self.activeMatches = matches;
            [self.collectionView reloadData];
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setNeedsStatusBarAppearanceUpdate];
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:176./255. green:65./255. blue:25./255. alpha:1.0]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:176./255. green:65./255. blue:25./255. alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:176./255. green:65./255. blue:25./255. alpha:1.0];
    self.collectionView.backgroundColor = [EXQConf colorViewBackgroundOrange];
    
    // Initialize recipe image array
    self.gameImages = @[@"download.jpeg",@"download1.jpeg",@"download2.jpeg",@"download3.jpeg",@"download5.jpeg",@"download6.jpeg", @"images.jpeg",@"images1.jpeg",@"images2.jpeg",@"images3.jpeg",@"images4.jpeg",@"images5.jpeg",@"images6.jpeg",@"images7.jpeg",@"images8.jpeg",@"images9.jpeg",@"images10.jpeg",@"images11.jpeg",@"images12.jpeg",@"images13.jpeg",@"images14.jpeg"];
}

@end
