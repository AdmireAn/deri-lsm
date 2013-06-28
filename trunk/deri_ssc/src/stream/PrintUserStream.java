/*
 * Copyright 2007 Yusuke Yamamoto
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package stream;

import twitter4j.DirectMessage;
import twitter4j.Status;
import twitter4j.StatusDeletionNotice;
import twitter4j.TwitterException;
import twitter4j.TwitterStream;
import twitter4j.TwitterStreamFactory;
import twitter4j.User;
import twitter4j.UserList;
import twitter4j.UserStreamListener;
import twitter4j.conf.ConfigurationBuilder;

/**
 * <p>
 * This is a code example of Twitter4J Streaming API - user stream.<br>
 * Usage: java twitter4j.examples.PrintUserStream. Needs a valid twitter4j.properties file with Basic Auth _and_ OAuth properties set<br>
 * </p>
 *
 * @author Yusuke Yamamoto - yusuke at mac.com
 * @author Rémy Rakic - remy dot rakic at gmail.com
 */
public final class PrintUserStream {
	static String TWITTER_ACCESS_TOKEN ="755832372-6BrszmduLdoxQAA1fsagtHsbMgzcAUIvCvbv09rQ";
	static String TWITTER_ACCESS_TOKEN_SECRET = "Jyb3Wo9O5EE7PwdkDxC7f0WmmmK9z3QDodJHQyIkr8M";
	static String TWITTER_CONSUMER_KEY = "bNksSWymSeBXXilrjvTVQ";
	static String TWITTER_CONSUMER_SECRET = "M8GqzEk1ILlhm0GKJk2aiSSqx8NafpfzD6pIaiGs";
	
    public static void main(String[] args) throws TwitterException {
    	ConfigurationBuilder confbuilder  = new ConfigurationBuilder(); 
        confbuilder.setOAuthAccessToken(TWITTER_ACCESS_TOKEN) 
        .setOAuthAccessTokenSecret(TWITTER_ACCESS_TOKEN_SECRET) 
        .setOAuthConsumerKey(TWITTER_CONSUMER_KEY) 
        .setOAuthConsumerSecret(TWITTER_CONSUMER_SECRET); 
        confbuilder.setJSONStoreEnabled(true);        
        
        TwitterStream twitterStream = new  TwitterStreamFactory(confbuilder.build()).getInstance();
//        TwitterStream twitterStream = new TwitterStreamFactory().getInstance();
        twitterStream.addListener(listener);
        // user() method internally creates a thread which manipulates TwitterStream and calls these adequate listener methods continuously.
        twitterStream.user();
    }

    static UserStreamListener listener = new UserStreamListener() {
        public void onStatus(Status status) {
            System.out.println("onStatus @" + status.getUser().getScreenName() + " - " + status.getText());
        }

        public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
            System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
        }

        public void onDeletionNotice(long directMessageId, long userId) {
            System.out.println("Got a direct message deletion notice id:" + directMessageId);
        }

        public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
            System.out.println("Got a track limitation notice:" + numberOfLimitedStatuses);
        }

        public void onScrubGeo(long userId, long upToStatusId) {
            System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
        }

        public void onFriendList(long[] friendIds) {
            System.out.print("onFriendList");
            for (long friendId : friendIds) {
                System.out.print(" " + friendId);
            }
            System.out.println();
        }

        public void onFavorite(User source, User target, Status favoritedStatus) {
            System.out.println("onFavorite source:@"
                    + source.getScreenName() + " target:@"
                    + target.getScreenName() + " @"
                    + favoritedStatus.getUser().getScreenName() + " - "
                    + favoritedStatus.getText());
        }

        public void onUnfavorite(User source, User target, Status unfavoritedStatus) {
            System.out.println("onUnFavorite source:@"
                    + source.getScreenName() + " target:@"
                    + target.getScreenName() + " @"
                    + unfavoritedStatus.getUser().getScreenName()
                    + " - " + unfavoritedStatus.getText());
        }

        public void onFollow(User source, User followedUser) {
            System.out.println("onFollow source:@"
                    + source.getScreenName() + " target:@"
                    + followedUser.getScreenName());
        }

        public void onRetweet(User source, User target, Status retweetedStatus) {
            System.out.println("onRetweet @"
                    + retweetedStatus.getUser().getScreenName() + " - "
                    + retweetedStatus.getText());
        }

        public void onDirectMessage(DirectMessage directMessage) {
            System.out.println("onDirectMessage text:"
                    + directMessage.getText());
        }

        public void onUserListMemberAddition(User addedMember, User listOwner, UserList list) {
            System.out.println("onUserListMemberAddition added member:@"
                    + addedMember.getScreenName()
                    + " listOwner:@" + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListMemberDeletion(User deletedMember, User listOwner, UserList list) {
            System.out.println("onUserListMemberDeleted deleted member:@"
                    + deletedMember.getScreenName()
                    + " listOwner:@" + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListSubscription(User subscriber, User listOwner, UserList list) {
            System.out.println("onUserListSubscribed subscriber:@"
                    + subscriber.getScreenName()
                    + " listOwner:@" + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListUnsubscription(User subscriber, User listOwner, UserList list) {
            System.out.println("onUserListUnsubscribed subscriber:@"
                    + subscriber.getScreenName()
                    + " listOwner:@" + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListCreation(User listOwner, UserList list) {
            System.out.println("onUserListCreated  listOwner:@"
                    + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListUpdate(User listOwner, UserList list) {
            System.out.println("onUserListUpdated  listOwner:@"
                    + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserListDeletion(User listOwner, UserList list) {
            System.out.println("onUserListDestroyed  listOwner:@"
                    + listOwner.getScreenName()
                    + " list:" + list.getName());
        }

        public void onUserProfileUpdate(User updatedUser) {
            System.out.println("onUserProfileUpdated user:@" + updatedUser.getScreenName());
        }

        public void onBlock(User source, User blockedUser) {
            System.out.println("onBlock source:@" + source.getScreenName()
                    + " target:@" + blockedUser.getScreenName());
        }

        public void onUnblock(User source, User unblockedUser) {
            System.out.println("onUnblock source:@" + source.getScreenName()
                    + " target:@" + unblockedUser.getScreenName());
        }

        public void onException(Exception ex) {
            ex.printStackTrace();
            System.out.println("onException:" + ex.getMessage());
        }
    };
}