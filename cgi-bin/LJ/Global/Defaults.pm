#!/usr/bin/perl
# This code was forked from the LiveJournal project owned and operated
# by Live Journal, Inc. The code has been modified and expanded by
# Dreamwidth Studios, LLC. These files were originally licensed under
# the terms of the license supplied by Live Journal, Inc, which can
# currently be found at:
#
# http://code.livejournal.org/trac/livejournal/browser/trunk/LICENSE-LiveJournal.txt
#
# In accordance with the original license, this code and all its
# modifications are provided under the GNU General Public License.
# A copy of that license can be found in the LICENSE file included as
# part of this distribution.
#
#
# Do not edit this file.  You should edit etc/config.pl.  If that file
# doesn't exist, copy it from doc/ljconfig.pl.txt to etc/config.pl and
# edit it there.  This file only provides backup default values for upgrading.
#

use strict;
no strict "vars";

{
    package LJ;
    use Sys::Hostname ();

    $DEFAULT_STYLE ||= {
        'core' => 'core1',
        'layout' => 'generator/layout',
        'i18n' => 'generator/en',
    };

    $DEFAULT_FEED_STYLE ||= {
        core => 'core2',
        layout => 'sitefeeds/layout',
        theme => 'sitefeeds/default',
    };

    # cluster 0 is no longer supported
    $DEFAULT_CLUSTER ||= 1;
    @CLUSTERS = (1) unless @CLUSTERS;

    $HOME = $LJ::HOME;
    $HTDOCS = "$HOME/htdocs";
    $BIN = "$HOME/bin";

    $SERVER_NAME ||= Sys::Hostname::hostname();

    $UNICODE = 1 unless defined $UNICODE;

    @LANGS = ("en") unless @LANGS;
    $DEFAULT_LANG ||= $LANGS[0];

    $SITENAME ||= "NameNotConfigured.com";
    unless ($SITENAMESHORT) {
        $SITENAMESHORT = $SITENAME;
        $SITENAMESHORT =~ s/\..*//;  # remove .net/.com/etc
    }
    $SITENAMEABBREV ||= "[??]";

    $MSG_READONLY_USER ||= "Database temporarily in read-only mode during maintenance.";

    $DOMAIN_WEB ||= "www.$DOMAIN";
    $SITEROOT ||= "http://$DOMAIN_WEB";
    $IMGPREFIX ||= "$SITEROOT/img";
    $STATPREFIX ||= "$SITEROOT/stc";
    $WSTATPREFIX ||= "$SITEROOT/stc";
    $JSPREFIX ||= "$SITEROOT/js";
    $USERPIC_ROOT ||= "$LJ::SITEROOT/userpic";
    $PALIMGROOT ||= "$LJ::SITEROOT/palimg";

    # path to sendmail and any necessary options
    $SENDMAIL ||= "/usr/sbin/sendmail -t -oi";

    # protocol, mailserver hostname, and preferential weight.
    # qmtp, smtp, dmtp, and sendmail are the currently supported protocols.
    @MAIL_TRANSPORTS = ( [ 'sendmail', $SENDMAIL, 1 ] ) unless @MAIL_TRANSPORTS;

    # roles that slow support queries should use in order of precedence
    @SUPPORT_SLOW_ROLES = ('slow') unless @SUPPORT_SLOW_ROLES;

    # where we set the cookies (note the period before the domain)
    $COOKIE_DOMAIN ||= ".$DOMAIN";

    $MAX_SCROLLBACK_LASTN ||= 100;
    $MAX_SCROLLBACK_FRIENDS ||= 1000;
    $MAX_USERPIC_KEYWORDS ||= 10;
    $MAX_ICONS_PER_PAGE = 50 unless defined $MAX_ICONS_PER_PAGE; # We want to be able to configure this to unlimited ( 0 )

    $LJ::AUTOSAVE_DRAFT_INTERVAL ||= 3;

    # this option can be a boolean or a URL, but internally we want a URL
    # (which can also be a boolean)
    if ($LJ::OPENID_SERVER && $LJ::OPENID_SERVER == 1) {
        $LJ::OPENID_SERVER = "$LJ::SITEROOT/openid/server";
    }

    # set default capability limits if the site maintainer hasn't.
    {
        my %defcap = (
                      'checkfriends' => 1,
                      'checkfriends_interval' => 60,
                      'friendsviewupdate' => 30,
                      'makepoll' => 1,
                      'maxfriends' => 500,
                      'moodthemecreate' => 1,
                      'styles' => 1,
                      's2styles' => 1,
                      's2props' => 1,
                      's2viewentry' => 1,
                      's2viewreply' => 1,
                      's2stylesmax' => 10,
                      's2layersmax' => 50,
                      'textmessage' => 1,
                      'userdomain' => 0,
                      'domainmap' => 0,
                      'useremail' => 0,
                      'userpics' => 5,
                      'findsim' => 1,
                      'full_rss' => 1,
                      'can_post' => 1,
                      'get_comments' => 1,
                      'leave_comments' => 1,
                      'mod_queue' => 50,
                      'mod_queue_per_poster' => 1,
                      'hide_email_after' => 0,
                      'userlinks' => 5,
                      'maxcomments' => 10000,
                      'maxcomments-before-captcha' => 5000,
                      'rateperiod-lostinfo' => 24*60, # 24 hours
                      'rateallowed-lostinfo' => 5,
                      'tools_recent_comments_display' => 50,
                      'rateperiod-invitefriend' => 60, # 1 hour
                      'rateallowed-invitefriend' => 20,
                      'subscriptions' => 25,
                      'usermessage_length' => 5000,
                      );
        foreach my $k (keys %defcap) {
            next if (defined $LJ::CAP_DEF{$k});
            $LJ::CAP_DEF{$k} = $defcap{$k};
        }
    }

    # FIXME: should forcibly limit userlinks to 255 (tinyint)

    # Send community invites from the admin address unless otherwise specified
    $COMMUNITY_EMAIL ||= $ADMIN_EMAIL;

    # The list of content types that we consider valid for gzip compression.
    %GZIP_OKAY = (
        'text/html' => 1,               # regular web pages; XHTML 1.0 "may" be this
        'text/xml' => 1,                # regular XML files
        'application/xml' => 1,         # XHTML 1.1 "may" be this
        'application/xhtml+xml' => 1,   # XHTML 1.1 "should" be this
        'application/rdf+xml' => 1,     # FOAF should be this
    ) unless %GZIP_OKAY;

    # maximum FOAF friends to return (so the server doesn't get overloaded)
    $MAX_FOAF_FRIENDS ||= 1000;

    # maximum number of friendofs to load/memcache (affects profile.bml display)
    $MAX_FRIENDOF_LOAD ||= 5000;

    # block size is used in stats generation code that gets n rows from the db at a time
    $STATS_BLOCK_SIZE ||= 10_000;

    # Maximum number of comments to display on Recent Comments page
    $TOOLS_RECENT_COMMENTS_MAX ||= 150;

    # setup the mogilefs defaults so we can create the necessary domains
    # and such. it is not recommended that you change the name of the
    # classes. you can feel free to add your own or alter the mindevcount
    # from within etc/config.pl, but the LiveJournal code uses these class
    # names elsewhere and depends on them existing if you're using MogileFS
    # for storage.
    #
    # also note that this won't actually do anything unless you have
    # defined a MOGILEFS_CONFIG hash in etc/config.pl and you explicitly set
    # at least the hosts key to be an arrayref of ip:port combinations
    # indicating where to reach your local MogileFS server.
    $MOGILEFS_CONFIG{domain}                 ||= 'livejournal';
    $MOGILEFS_CONFIG{timeout}                ||= 3;

    $MOGILEFS_CONFIG{classes}                ||= {};
    $MOGILEFS_CONFIG{classes}->{temp}        ||= 2;
    $MOGILEFS_CONFIG{classes}->{userpics}    ||= 3;
    $MOGILEFS_CONFIG{classes}->{vgifts}      ||= 3;
    $MOGILEFS_CONFIG{classes}->{media}       ||= 3;

    # Default to allow all reproxying.
    %REPROXY_DISABLE = () unless %REPROXY_DISABLE;


    # detect whether we are running on 32-bit architecture
    my $arch = ( length(pack "L!", 0) == 4 ) ? 1 : 0;
    if ( defined $ARCH32 ) {
        die "Can't have ARCH32 set to false on a 32-bit architecture" if $ARCH32 <
    $arch;
    } else {
        $ARCH32 = $arch;
    }


    # setup default minimal style information
    $MINIMAL_USERAGENT{$_} ||= 1 foreach qw(Links Lynx w BlackBerry WebTV); # w is for w3m
    $MINIMAL_BML_SCHEME ||= 'lynx';
    $MINIMAL_STYLE{'core'} ||= 'core1';

    # maximum size to cache s2compiled data
    $MAX_S2COMPILED_CACHE_SIZE ||= 7500; # bytes

    # max content length we should read via ATOM api
    # 25MB
    $MAX_ATOM_UPLOAD ||= 26214400;

    $DEFAULT_EDITOR ||= 'rich';

    unless (@LJ::EVENT_TYPES) {
        @LJ::EVENT_TYPES = map { "LJ::Event::$_" }
                           qw (
                               AddedToCircle
                               Birthday
                               CommunityInvite
                               CommunityJoinApprove
                               CommunityJoinReject
                               CommunityJoinRequest
                               ImportStatus
                               InvitedFriendJoins
                               JournalNewComment
                               JournalNewComment::TopLevel
                               JournalNewComment::Edited
                               JournalNewComment::Reply
                               JournalNewEntry
                               NewUserpic
                               OfficialPost
                               PollVote
                               RemovedFromCircle
                               SecurityAttributeChanged
                               UserExpunged
                               UserMessageRecvd
                               UserMessageSent
                               VgiftApproved
                               XPostFailure
                               XPostSuccess
                               );
    }

    unless (@LJ::NOTIFY_TYPES) {
        @LJ::NOTIFY_TYPES = map { "LJ::NotificationMethod::$_" }
                            qw ( Email );
    }

    # random user defaults to a week
    $RANDOM_USER_PERIOD = 7;

    # how far in advance to send out birthday notifications
    $LJ::BIRTHDAY_NOTIFS_ADVANCE ||= 2*24*60*60;

    # "RPC" URI mappings
    # add default URI handler mappings
    my %ajaxmapping = (
                       delcomment     => "delcomment.bml",
                       talkscreen     => "talkscreen.bml",
                       controlstrip   => "tools/endpoints/controlstrip.bml",
                       ctxpopup       => "tools/endpoints/ctxpopup.bml",
                       changerelation => "tools/endpoints/changerelation.bml",
                       userpicselect  => "tools/endpoints/getuserpics.bml",
                       esn_inbox      => "tools/endpoints/esn_inbox.bml",
                       esn_subs       => "tools/endpoints/esn_subs.bml",
                       trans_save     => "tools/endpoints/trans_save.bml",
                       dirsearch      => "tools/endpoints/directorysearch.bml",
                       jobstatus      => "tools/endpoints/jobstatus.bml",
                       widget         => "tools/endpoints/widget.bml",
                       multisearch    => "tools/endpoints/multisearch.bml",
                       extacct_auth   => "tools/endpoints/extacct_auth.bml",
                       contentfilters => "tools/endpoints/contentfilters.bml",
                       general        => "tools/endpoints/general.bml",
                       );

    foreach my $src (keys %ajaxmapping) {
        $LJ::AJAX_URI_MAP{$src} ||= $ajaxmapping{$src};
    }
    $LJ::AJAX_URI_MAP{load_state_codes} = 'tools/endpoints/load_state_codes.bml';
    $LJ::AJAX_URI_MAP{profileexpandcollapse} = 'tools/endpoints/profileexpandcollapse.bml';

    # List all countries that have states listed in 'codes' table in DB
    # These countries will be displayed with drop-down menu on Profile edit page
    # 'type' is used as 'type' attribute value in 'codes' table
    # 'save_region_code' specifies what to save in 'state' userprop  -
    # '1' mean save short region code and '0' - save full region name
    %LJ::COUNTRIES_WITH_REGIONS = (
        'US' => { type => 'state', save_region_code => 1, },
        'RU' => { type => 'stateru', save_region_code => 1, },
        #'AU' => { type => 'stateau', save_region_code => 0, },
        #'CA' => { type => 'stateca', save_region_code => 0, },
        #'DE' => { type => 'statede', save_region_code => 0, },
    );

    %LJ::VALID_PAGE_NOTICES = (
        profile_design => 1,
        settings_design => 1,
    );

    $SUBDOMAIN_RULES = {
        P => [ 1, "users.$LJ::DOMAIN" ],
        Y => [ 1, "syndicated.$LJ::DOMAIN" ],
        C => [ 1, "community.$LJ::DOMAIN" ],
    };

    $LJ::USERSEARCH_METAFILE_PATH ||= "$HOME/var/usersearch.data";

    # default to limit to 2000 results
    $LJ::MAX_DIR_SEARCH_RESULTS ||= 2000;

    # default to limit to 50,000 watch or trust edges to load
    $LJ::MAX_WT_EDGES_LOAD ||= 50_000;

    # to avoid S2 error "Excessive recursion detected and stopped."
    $S2::MAX_RECURSION ||= 500;

    # limit number of tags to search in intersection mode
    $LJ::TAG_INTERSECTION ||= 20;

    # not expected to need to be changed
    # default priority for libraries and resources in a sitescheme,
    # so that they come before any stylesheets declared by the page itself
    $LJ::LIB_RES_PRIORITY = 3;
    $LJ::SCHEME_RES_PRIORITY = 3;

    # FIXME: remove the need for this, it's a hack of a hack of a hack
    # it used to be that site scheme pages were called later than page-level CSS
    # so page-level CSS was written with that assumption, and overrode some colors
    # now that site scheme pages are called earlier than page-level CSS
    # (as they should be) some pages look weird.
    # So let us temporarily force old behavior on existing files
    $LJ::OLD_RES_PRIORITY = 5;

    # mapping of captcha type to specific desired implementation
    %CAPTCHA_TYPES = (
        "T" => "textcaptcha",   # "T" is for text
        "I" => "recaptcha",     # "I" is for image
    ) unless %CAPTCHA_TYPES;
    $DEFAULT_CAPTCHA_TYPE ||= "T";

    # default location of community posting guidelines
    $DEFAULT_POSTING_GUIDELINES_LOC ||= "N";

    # Secrets
    %SECRETS = () unless %SECRETS;

    # Userpic maximum. No user can have more than this.
    $USERPIC_MAXIMUM ||= 500;
}


1;
