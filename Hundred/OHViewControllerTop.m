//
//  OHViewControllerTop.m
//  OneHundred
//
//  Created by Вадим on 02.08.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewControllerTop.h"
#import "OHTableViewCell.h"

@interface OHViewControllerTop ()
{
    bool _d6d3;
    bool _rep;
    NSMutableArray *_scoreDatas;
}

- (void) loadPlayerData;

@end


@implementation OHViewControllerTop

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Top", nil)];
    [self.navigationController.navigationBar.topItem setTitle:NSLocalizedString(@"BackGame", nil)];

    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans-Semibold" size:11.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.resours.colorblackActive, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    [self.segmented6d3 setTitle:NSLocalizedString(@"6digits", nil) forSegmentAtIndex:0];
    [self.segmented6d3 setTitle:NSLocalizedString(@"3digits", nil) forSegmentAtIndex:1];
    [self.segmentedRep setTitle:NSLocalizedString(@"TopRep", nil) forSegmentAtIndex:0];
    [self.segmentedRep setTitle:NSLocalizedString(@"TopNoRep", nil) forSegmentAtIndex:1];

    _d6d3 = YES;
    _rep = NO;
    [self loadPlayerData];
}

- (IBAction)segmentedChangeds:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    NSInteger tag = [segmented tag];
    NSInteger index = [segmented selectedSegmentIndex];
    
    if (tag == 0) {
        if (index == 0) {
            _d6d3 = YES;
        } else if(index == 1) {
            _d6d3 = NO;
        }
    } else if(tag == 1) {
        if (index == 0) {
            _rep = YES;
        } else if(index == 1) {
            _rep = NO;
        }
    }

    [self loadPlayerData];
}

- (void) loadPlayerData;
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil) {
        int idIndexObj = _d6d3 && _rep?0:_d6d3 && !_rep?1:!_d6d3 && _rep?2:3;

        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.category = [self.resours.leaderboardIDs objectAtIndex:idIndexObj];
        leaderboardRequest.range = NSMakeRange(1, 25);
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;

        _scoreDatas = [[NSMutableArray alloc] init];
        [self.segmented6d3 setEnabled:NO];
        [self.segmentedRep setEnabled:NO];
        [self.loader setHidden:NO];

        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            NSArray *playerIDs = [scores valueForKeyPath:@"playerID"];
            [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *playerArray, NSError *error) {
                int i = 0;

                GKScore *localScore = leaderboardRequest.localPlayerScore;
                GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
                if (localScore != nil) {
                    [_scoreDatas addObject:[[NSArray alloc] initWithObjects:
                                            [NSString stringWithFormat:@"%@.", [NSString stringWithFormat:@"%ld",(long)localScore.rank]],
                                            [NSString stringWithFormat:@"%@", localPlayer.displayName],
                                            [NSString stringWithFormat:@"%@", localScore.formattedValue], nil]];
                }

                for (GKPlayer *player in playerArray) {
                    if (localPlayer.playerID != player.playerID) {
                        GKScore *score = [scores objectAtIndex:i];
                        [_scoreDatas addObject:[[NSArray alloc] initWithObjects:
                                                [NSString stringWithFormat:@"%@.", [NSString stringWithFormat:@"%ld",(long)score.rank]],
                                                [NSString stringWithFormat:@"%@", player.displayName],
                                                [NSString stringWithFormat:@"%@", score.formattedValue], nil]];
                    }
                    i += 1;
                }
                [self.segmented6d3 setEnabled:YES];
                [self.segmentedRep setEnabled:YES];
                [self.loader setHidden:YES];
                [self.tableView reloadData];
            }];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_scoreDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTop"];
    NSInteger i = [indexPath row];
    NSArray *tmp = [[NSArray alloc] initWithArray:[_scoreDatas objectAtIndex:i]];
    
    [cell.cellRate setText:[tmp objectAtIndex:0]];
    [cell.cellDesk setText:[tmp objectAtIndex:1]];
    [cell.cellTemer setText:[tmp objectAtIndex:2]];

    return cell;
}

@end
