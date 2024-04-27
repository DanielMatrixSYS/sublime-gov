--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeGov.Languages["en"] = 
{
    this_language = "English",

    -- Basic stuff.
    ui_exit = "Exit",
    ui_ok   = "OK",
    ui_no   = "NO",
    
    -- Login page.
    ui_login_login                          = "Login",
    ui_login_header                         = "Secured Government System",
    ui_login_footer                         = "This is a secured and monitored Federal Government system. Unauthorized access is strictly prohibited. All activity is fully monitored.\nIndividuals who attempt to gain unauthorized access or attempt any modification of information on this system is subject to criminal prosecution.\nAll persons who are hereby notified that use of this system constitutes to monitoring and auditing.",
    ui_login_title                          = "Sublime Government - ",
    ui_login_not_logged_in                  = "NOT LOGGED IN",
    ui_login_please                         = "To access the system you have to be logged in.",
    ui_login_or                             = "OR",
    ui_login_username                       = "Username",
    ui_login_bad_username                   = "Username not recognized.",
    ui_login_bad_username_desc              = "The entered username is not recognized in our system.",
    ui_login_password                       = "Password",
    ui_login_bad_password                   = "Incorrect password.",
    ui_login_bad_password_desc              = "The password associated with this account is incorrect.",
    ui_login_is_government                  = "Is Government Official",
    ui_login_bad_is_government              = "Government ID not found.",
    ui_login_bad_is_government_desc         = "Only official government employees may access this system.\nYour presence has been logged.",
    ui_login_ip                             = "IP Address",
    ui_login_established_connect            = "Connection Established",
    ui_login_bad_established_connect        = "Unable to connect.",
    ui_login_bad_established_connect_desc   = "Unable to connect to the system, it seems to be down at the moment.",
    ui_login_proceed                        = "Proceed with the connection",
    ui_login_proceed_unable                 = "Unable to proceed with the connection. Please abort.",
    ui_login_show                           = "Show more information.",
    ui_login_abort                          = "Abort",

    -- Main connected page.
    ui_connected_logged_in  = "LOGGED IN",
    ui_connected_as_a       = "AS A",
    ui_connected_on         = "ON",

    -- This is used for the arrests & release records page.
    ui_connected_arrested_by                = "was arrested by",
    ui_connected_released_in                = "and will be released in",
    ui_connected_disconnected               = "Disconnected",
    ui_connected_disconnected_description   = "This player has disconnected from the server.",
    ui_connected_profile                    = "'s Profile",
    ui_connected_jail_empty                 = "There is currently no one in jail.",
    ui_connected_arrested_criminals         = "Currently arrested criminals",
    ui_connected_was_released               = "was released",
    ui_connected_by                         = "by",
    ui_connected_ago                        = "ago",
    ui_connected_none_recently_released     = "No one has been recently released.",
    ui_connected_recently_released          = "Recently released criminals",
    ui_connected_arrest_release             = "Arrest & Release",
    ui_connected_personal                   = "Personal Information",
    ui_connected_criminal                   = "Criminal Record",
    ui_connected_other                      = "Other",
    ui_connected_name                       = "Name",
    ui_connected_age_type                   = "Age Type",
    ui_connected_race                       = "Race",
    ui_connected_height                     = "Height",
    ui_connected_occupation                 = "Occupation",
    ui_connected_health_status              = "Health Status",
    ui_connected_wealth_status              = "Wealth Status",
    ui_connected_personal_police            = "Police Record",

    -- This is used for the agenda at the home page.
    ui_agenda_edit_agenda       = "Edit Agenda",
    ui_agenda_edit_description  = "What should the new agenda be, %s?",
    ui_agenda_empty             = "There is no offical agenda, yet.",

    -- This is used for the leaderbaorsd at the home page.
    ui_leaderboards_tota_time_spent = "Total time spent on duty:",
    ui_leaderboards_top_10          = "Top 10 Officers Online",
    ui_leaderboards_empty           = "There are either no Government Employees online or there is no data to display!",

    -- This is used for the actual home page.
    ui_recent_news      = "Recent News",
    ui_no_recent_news   = "There are no recent news.",
    ui_home             = "Home",

    -- This is used for the profile at the home page.
    ui_profile_statistics = "Your profile",

    -- Main page.
    ui_app_home                             = "Home",
    ui_app_arrests_and_release              = "Arrests & Releases",
    ui_app_wanted_warrants                  = "Wanted & Warrants",
    ui_app_licenses                         = "Licenses",
    ui_app_police                           = "Police Leaderboards",
    ui_app_statistics                       = "Statistics",
    ui_app_applications                     = "Applications",
    
    ui_app_main_apps                        = "Main Applications",
    ui_app_mayor                            = "Mayor",
    ui_app_mayor_employees                  = "Manage Employees",
    ui_app_mayor_lottery                    = "Manage Lottery",
    ui_app_mayor_laws                       = "Manage Laws",
    ui_app_mayor_salaries                   = "Manage Salaries",
    ui_app_mayor_taxes                      = "Manage Taxes",
    ui_app_mayor_taxes_disabled             = "Taxes are disabled",
    ui_app_mayor_taxes_disabled_desc        = "The taxes are currently disabled, would you like to enable them?",
    ui_app_mayor_taxes_disabled_admin_desc  = "The taxes are disabled and can not be enabled by you because the server owner has not enabled this. If you are the server owner then look inside of the config!",
    ui_app_admin                            = "Admin Settings",
    ui_app_admin_database                   = "Database",
    ui_app_admin_credits                    = "Credits",
    ui_app_exit                             = "Exit System",

    -- Leaderboards page.
    ui_leaderboards_title   = "Police Leaderboards",
    ui_viewing_page         = "Viewing page: %i/%i",

    -- Statistics page.

    ui_statistics_kills             = "Kills";
    ui_statistics_wanted_count      = "Wanted";
    ui_statistics_teamkills         = "Team Kills";
    ui_statistics_deaths            = "Deaths";
    ui_statistics_warranted_count   = "Warranted";
    ui_statistics_confiscated_count = "Confiscated";
    ui_statistics_arrested_count    = "Arrested";
    ui_statistics_released_count    = "Released";
    ui_statistics_ram_count         = "Rammed";
    ui_statistics_salary_total      = "Salary";
    ui_statistics_seconds_on_duty   = "Hours on duty";
    ui_statistics_damage_dealt      = "Damage Dealt";

    -- Notifications
    ui_notification_accept  = "Accept",
    ui_notification_decline = "Decline",
    ui_notification_reason_short  = "Keep the reason short",

    -- Database
    ui_database_wipe_police_database        = "Wipe Police Database",
    ui_database_wipe_police_desc            = "Are you sure you want to reset the police database? This can't be undone. An automatic map change will be issued upon accepting.",
    ui_database_wipe_criminal_database      = "Wipe Criminal Database",
    ui_database_wipe_criminal_database_desc = "Are you sure you want to reset the criminal database? This can't be undone. An automatic map change will be issued upon accepting.",
    ui_database_wipe_computers              = "Wipe Government Computer Positions",
    ui_database_wipe_computers_desc         = "Are you sure you want to reset the government computer positions? This can't be undone. An automatic map change will be issued upon accepting.",
    ui_database_wipe_everything             = "Wipe Everything",
    ui_database_wipe_everything_desc        = "Are you sure you want to reset everything? This can't be undone. An automatic map change will be issued upon accepting.",
    ui_database_are_you_sure                = "Are you sure?",
    ui_database                             = "Database",

    -- License
    ui_license_occupation                   = "Occupation",
    ui_license_has_license                  = "Has License",
    ui_license_yes                          = "Yes",
    ui_license_no                           = "No",
    ui_licenses                             = "Licenses",

    -- Mayor
    ui_mayor_salary                         = "Salary",
    ui_mayor_demote                         = "Are you sure you want to force a demote on %s?",
    ui_mayor_employees                      = "Employees",
    ui_mayor_employees_desc                 = "You can demote people by clicking on one of the rows.",

    ui_mayor_laws_reset_laws                = "Reset Laws",
    ui_mayor_reset                          = "Reset?",
    ui_mayor_are_you_sure                   = "Are you sure you want to reset every law?",
    ui_mayor_law_add                        = "Add Law",
    ui_mayor_law_create                     = "Create Law",
    ui_mayor_what                           = "What should this law be?",
    ui_mayor_change_or                      = "Change or Remove?",
    ui_mayor_change_or_decs                 = "Do you want to change or remove this law?",
    ui_mayor_change                         = "Change",
    ui_mayor_remove                         = "Remove",
    ui_mayor_edit                           = "Edit Law: %s",
    ui_mayor_what_change                    = "What would you like to change about this law?",
    ui_mayor_cant_edit                      = "Can't edit",
    ui_mayor_cant_edit_desc                 = "You can't edit this law",
    ui_mayor_laws                           = "Laws",

    ui_mayor_lottery_won                    = "won the lottery",
    ui_mayor_lottery_stunning               = "With a stunning amount of",
    ui_mayor_lottery                        = "Lottery",
    ui_mayor_lottery_desc                   = "This shows all of the players who've won the lottery and how much they've earned(Session based)",
    ui_mayor_lottery_noone                  = "No one has won the lottery yet, start one now!",

    ui_mayor_taxes_save                     = "Save Tax Changes",
    ui_mayor_taxes_save_success             = "Success",
    ui_mayor_taxes_save_success_desc        = "Taxes successfully changed",

    ui_mayor_taxes_default                  = "Change To Default",
    ui_mayor_taxes_default_success_desc     = "Taxes have been reset to default",

    ui_mayor_taxes_disable                  = "Disable Taxes",
    ui_mayor_taxes_disable_success_desc     = "You have successfully disabled the taxing system",

    ui_mayor_taxes              = "Taxes",
    ui_mayor_taxes_disabled     = "Taxes is disabled",

    ui_mayor_taxes_property     = "Property Tax\n %s%%",
    ui_mayor_taxes_sales        = "Sales Tax\n %s%%",
    ui_mayor_taxes_salary       = "Salary Tax\n %s%%",

    ui_stats_combat         = "Combat",
    ui_stats_general        = "General",
    ui_stats_other          = "Other",
    ui_stats_global         = "Global Government Statistics",
    ui_stats_together       = "These numbers are added together",

    ui_wanted_noone         = "No one is currently wanted.",
    ui_wanted_current       = "Currently wanted criminals",

    ui_warranted_noone      = "No one is currently warranted.",
    ui_warranted_current    = "Currently warranted criminals",

    ui_wanted_and_warrants  = "Wanted & Warrants",

    ui_make_wanted          = "Make Wanted",
    ui_remove_wanted        = "Remove Wanted",
    ui_make_warrant         = "Make Warrant",
    ui_remove_warrant       = "Remove Warrant",
    ui_grant_license        = "Grant License",
    ui_revoke_license       = "Revoke License",
    ui_quick_start_lottery  = "Quick Start Lottery",
    ui_quick_start_lockdown = "Start Lockdown",
    ui_quick_stop_lockdown  = "Stop Lockdown",
    ui_are_you_sure_quick   = "Are you sure you want to quick start a lottery?",
    ui_select_a_player      = "Select a player to %s",
    ui_start_lockdown       = "Are you sure you want to start a lockdown?",
    ui_stop_lockdown        = "Are you sure you want to stop the lockdown?",
    ui_lockdown             = "Lockdown",

    ui_make_wanted_desc     = "Are you sure you want to quick wanted this player?",
    ui_remove_wanted_desc   = "Are you sure you want to quick remove this players wanted level?",
    ui_make_warrant_desc    = "Are you sure you want to quick warrant this player?",
    ui_remove_warrant_desc  = "Are you sure you want to quick remove this players warrant level?",
    ui_grant_license_desc   = "Are you sure you want to grant this player a gun license?",
    ui_revoke_license_desc  = "Are you sure you want to revoke this players gun license?",

    ui_player_disconnect        = "Player Disconnected",
    ui_player_disconnect_desc   = "This player has disconnected from the server",

    ui_player_search        = "Search for player names and steamids...",
    ui_player_invalid       = "Invalid player selected",
    ui_player_is_bot        = "The selected player is a bot and can not be targeted from this menu",

    ui_create_notes         = "Create Note",
    ui_add_note             = "Add Note",
    ui_add_note_desc        = "Add a small note on this player's profile for other government employees to see. The note can only hold 300 characters",
    ui_add_woah             = "Woah",
    ui_add_max              = "Notes can only hold a maximum of 300 characters, yours is currently at %s",
    ui_add_notes_cd         = "Notes Cooldown",
    ui_add_note_post_new    = "You can post a new note in %s",
    ui_note_title           = "Player Notes",
    ui_note_zero            = "This player does not have any notes, create one now!",
    
    ui_mayor_salary_disabled                = "The taxes are disabled which means the salaries are disabled, unfortunately.",
    ui_mayor_salary_disabled_noti           = "The taxes are currently disabled which means the salaries are disabled. Enable the taxes by clicking on the 'Manage Taxes' button.",
    ui_mayor_salary_disabled_config         = "Salaries disabled",
    ui_mayor_salary_disabled_config_desc    = "You are unable to manage the salaries because it is disabled.",
    ui_mayor_salary_and_mayor_gets_money    = "Both, 'SublimeGov.Config.MayorCanAdjustSalaries' and 'SublimeGov.Config.MayorGetsMoney' variables are set to true in the config, only one can be enabled at the time. Set one of them to false.",
    ui_mayor_salary_mayor_gets_money        = "Salaries are currently disabeld. The tax fund goes straight into your wallet instead. Enabling salaries will allow you to distribute the tax fund across extra paychecks instead.\n\nYou can enable the salaries from the 'Manage tax' application.",
   
    ui_mayor_tax_fund = "Tax Fund: %s",

    tool_spawn      = "Left click to spawn.",
    tool_delete     = "Right click to delete.",
    tool_save       = "Reload to save",

    ui_mayor_taxes_change_dis   = "Disable Extra Salary",
    ui_mayor_taxes_change_ena   = "Enable Extra Salary",

    ui_mayor_taxes_change_dis_desc  = "Extra salary disabled.",
    ui_mayor_taxes_change_ena_desc  = "Extra salary enabled.",

    -- These are used after you select a playere for a wanted, warrant, or whatever.
    ui_connected_wanted_title = "Wanted Reason",
    ui_connected_wanted_reason = "Reasoning for making %s wanted?",
    ui_connected_warrant_title = "Warrant Reason",
    ui_connected_warrant_reason = "Reasoning for making %s warranted?",
}