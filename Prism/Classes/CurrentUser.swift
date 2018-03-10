//
//  CurrentUser.swift
//  Prism
//
//  Created by Shiv Shah on 3/5/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase

public class CurrentUser {
    
    /*
     * Globals
     */
    private static var auth: Auth!
    public static var firebaseUser: User!
    private static var userReference: DatabaseReference!
    private static var allPostReference: DatabaseReference!
    
    
    /**
     * Key: String postId
     * Value: long timestamp
     **/
    public static var liked_posts_map: [String : Int64]!
    public static var reposted_posts_map: [String : Int64]!
    private static var uploaded_posts_map: [String : Int64]!
    
    /* ArrayList of PrismPost object for above structures */
    public static var liked_posts: Array<PrismPost>!
    public static var reposted_posts: Array<PrismPost>!
    public static var uploaded_posts: Array<PrismPost>!
    
    /**
     * Key: String username
     * Value: String uid
     */
    public static var followers: [String : String]!
    public static var followings: [String : String]!
    
    public static var prismUser: PrismUser!
    
//    public CurrentUser(Context context) {
//    auth = FirebaseAuth.getInstance();
//    firebaseUser = auth.getCurrentUser();
//    userReference = Default.USERS_REFERENCE.child(firebaseUser.getUid());
//    allPostReference = Default.ALL_POSTS_REFERENCE;
//
//    CurrentUser.context = context;
//    scale = context.getResources().getDisplayMetrics().density;
//
//    refreshUserRelatedEverything();
//    getUserProfileDetails();
//    }
    
    /**
     * Refreshes list of liked, reposted and uploaded posts by current firebaseUser
     * TODO: need a better function name lol
     *
     */
//    public static void refreshUserRelatedEverything() {
//    refreshUserLikedPosts();
//    refreshUserRepostedPosts();
//    refreshUserUploadedPosts();
//    refreshUserFollowersAndFollowings();
//    }
//
//    /**
//     *
//     */
//    private static void refreshUserFollowersAndFollowings() {
//    followers = new HashMap<String, String>();
//    followings = new HashMap<String, String>();
//    userReference.addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    if (dataSnapshot.hasChild(Key.DB_REF_USER_FOLLOWERS)) {
//    followers.putAll((Map) dataSnapshot.child(Key.DB_REF_USER_FOLLOWERS).getValue());
//    }
//    if (dataSnapshot.hasChild(Key.DB_REF_USER_FOLLOWINGS)) {
//    followings.putAll((Map) dataSnapshot.child(Key.DB_REF_USER_FOLLOWINGS).getValue());
//    }
//    } else {
//    Log.wtf(Default.TAG_DB, Message.NO_DATA);
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, databaseError.getMessage(), databaseError.toException());
//    }
//    });
//
//    }
//
//    /**
//     * Pulls current firebaseUser's list of liked posts and puts them in a HashMap
//     */
//    public static void refreshUserLikedPosts() {
//    liked_posts = new ArrayList<>();
//    liked_posts_map = new HashMap<String, Long>();
//    userReference.child(Key.DB_REF_USER_LIKES).addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    liked_posts_map.putAll((Map) dataSnapshot.getValue());
//    allPostReference.addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    for (Object key : liked_posts_map.keySet()) {
//    String postId = (String) key;
//    DataSnapshot postSnapshot = dataSnapshot.child(postId);
//    if (postSnapshot.exists()) {
//    PrismPost prismPost = Helper.constructPrismPostObject(postSnapshot);
//    //TODO: Pull user info for the given liked PrismPost
//    prismPost.setPrismUser(CurrentUser.prismUser);
//    liked_posts.add(prismPost);
//    }
//    }
//    } else {
//    Log.i(Default.TAG_DB, Message.NO_DATA);
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, Message.FETCH_POST_INFO_FAIL, databaseError.toException());
//    }
//    });
//    }
//    }
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, databaseError.getMessage(), databaseError.toException());
//    }
//    });
//    }
//
//    /**
//     * Pulls current firebaseUser's list of reposted posts and puts them in a HashMap
//     */
//    public static void refreshUserRepostedPosts() {
//    reposted_posts = new ArrayList<>();
//    reposted_posts_map = new HashMap<String, Long>();
//    userReference.child(Key.DB_REF_USER_REPOSTS).addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    reposted_posts_map.putAll((Map) dataSnapshot.getValue());
//    allPostReference.addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    for (Object key : reposted_posts_map.keySet()) {
//    String postId = (String) key;
//    DataSnapshot postSnapshot = dataSnapshot.child(postId);
//    if (postSnapshot.exists()) {
//    PrismPost prismPost = Helper.constructPrismPostObject(postSnapshot);
//    //TODO: Pull user info for the given reposted PrismPost
//    prismPost.setPrismUser(CurrentUser.prismUser);
//    reposted_posts.add(prismPost);
//    }
//    }
//    } else {
//    Log.i(Default.TAG_DB, Message.NO_DATA);
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, Message.FETCH_POST_INFO_FAIL, databaseError.toException());
//    }
//    });
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, databaseError.getMessage(), databaseError.toException());
//    }
//    });
//    }
//
//    /**
//     * TODO: convert items to PrismPost or something for User Profile Page
//     */
//    public static void refreshUserUploadedPosts() {
//    uploaded_posts = new ArrayList<>();
//    uploaded_posts_map = new HashMap<String, Long>();
//    userReference.child(Key.DB_REF_USER_UPLOADS).addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    uploaded_posts_map.putAll((Map) dataSnapshot.getValue());
//    allPostReference.addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    for (Object key : uploaded_posts_map.keySet()) {
//    String postId = (String) key;
//    DataSnapshot postSnapshot = dataSnapshot.child(postId);
//    if (postSnapshot.exists()) {
//    PrismPost prismPost = Helper.constructPrismPostObject(postSnapshot);
//    prismPost.setPrismUser(CurrentUser.prismUser);
//    uploaded_posts.add(prismPost);
//    }
//    }
//    } else {
//    Log.wtf(Default.TAG_DB, Message.NO_DATA);
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, Message.FETCH_POST_INFO_FAIL, databaseError.toException());
//    }
//    });
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, databaseError.getMessage(), databaseError.toException());
//    }
//    });
//    }
//
//
//    /**
//     * Gets firebaseUser's profile details such as full name, username,
//     * and link to profile pic uri
//     */
//    public void getUserProfileDetails() {
//    userReference.addListenerForSingleValueEvent(new ValueEventListener() {
//    @Override
//    public void onDataChange(DataSnapshot dataSnapshot) {
//    if (dataSnapshot.exists()) {
//    prismUser = Helper.constructPrismUserObject(dataSnapshot);
//    updateUserProfilePageUI();
//    }
//    }
//
//    @Override
//    public void onCancelled(DatabaseError databaseError) {
//    Log.e(Default.TAG_DB, databaseError.getMessage(), databaseError.toException());
//    }
//    });
//    }
    
    
}
