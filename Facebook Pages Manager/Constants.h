//
//  Constants.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 8/2/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define READ_PERMISSIONS  @[@"public_profile", @"email", @"user_friends",@"read_insights"]
#define PUBLISH_PERMISSIONS @[@"manage_pages", @"publish_pages",@"publish_actions"]

#pragma mark - Requests

static NSString* const accountsRequest = @"me/accounts";
static NSString* const feedPath = @"/feed";
static NSString* const pageFeedPath = @"/%@/feed";
static NSString* const insights_postImpressions = @"%@/insights?metric=post_impressions";
static NSString* const promotablePostsPath = @"/promotable_posts";
static NSString* const pictureRequestPath = @"/%@/picture?fields=url&type=small&redirect=0";
static NSString* const oauthPath = @"oauth/access_token";
static NSString* const createTestUsersPath =  @"/%@/accounts/test-users";

#pragma mark - RequestParams
#define FEED_PARAMS @{ @"fields": @"id,full_picture,object_id,name,message,created_time, is_hidden, is_published,privacy,type,from",}
#define PAGES_PARAMS @{@"fields":@"access_token,category,id,name,perms,picture",}
#define scheduledPostsParams @{ @"fields": @"id,full_picture,object_id,name,message,created_time, is_hidden, is_published,privacy,type,from",@"is_published":@"false"}
#define POST_VIEWS_PARAM @{@"fields":@"id,values,name"}
#define APP_ACCESS_PARAM @{@"client_id":@"651682695041859",@"client_secret":@"6d284fa001553acfbecd3cfce2f763a7",@"grant_type":@"client_credentials"}
#define TEST_USER_PERMS @{@"permissions":@"public_profile, email, user_friends, read_insights,publish_actions", @"installed": @"true"}

static NSString* const graphAPIVersion = @"v2.10";
static NSString* const backdatedTimeParam = @"backdated_time";
static NSString* const scheduledPublishTimeParam = @"scheduled_publish_time";
static NSString* const publishedParam = @"published";

#pragma mark - jsonParams
static NSString* const idKey = @"id";
static NSString* const nameKey = @"name";
static NSString* const typeKey = @"type";
static NSString* const dataKey = @"data";
static NSString* const accessTokenKey = @"access_token";
static NSString* const pictureKey = @"picture";
static NSString* const valuesKey = @"values";
static NSString* const valueKey = @"value";
static NSString* const urlKey = @"url";
static NSString* const messageKey = @"message";
static NSString* const fromKey = @"from";
static NSString* const createdTimeKey = @"created_time";

#pragma mark - HTTPMethods
static NSString* const HTTP_GET = @"GET";
static NSString* const HTTP_PUT = @"PUT";
static NSString* const HTTP_POST = @"POST";
static NSString* const HTTP_DELETE = @"DELETE";

#pragma mark - values
static NSString* const photoPost = @"photo";

#pragma mark - PERMISSIONS
static NSString* const managePages = @"manage_pages";
static NSString* const publishPages = @"publish_pages";

#pragma mark - Notifications
static NSString* const reloadPageNotification = @"reloadPageFeed";

#pragma mark - otherConstants
#define ESTIMATED_ROW_HEIGHT 531
static NSString* const savedPostsKeyInDefaults= @"savedPosts";
static NSString* const  appID = @"651682695041859";
static NSString* const  appSecret = @"6d284fa001553acfbecd3cfce2f763a7";
#endif /* Constants_h */
