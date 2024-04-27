--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeGov.Languages["fr"] = 
{
    this_language = "Français",

    -- Basic stuff.
    ui_exit = "Quitter",
    ui_ok   = "OK",
    ui_no   = "NON",
    
    -- Login page.
    ui_login_login                          = "S'identifier",
    ui_login_header                         = "Système Gouvernemental Sécurisé",
    ui_login_footer                         = "Il s'agit d'un système gouvernementale sécurisé et surveillé. L'accès non autorisé est strictement interdit. Toutes les activités sont surveillées. \nLes personnes qui tentent d'obtenir un accès non autorisé ou de modifier des informations sur ce système sont passibles de poursuites pénales. \nToutes les personnes sont averties par la présente que l'utilisation de ce système fait l'objet d'un suivi et d'un audit.",
    ui_login_title                          = "Sublime Government - ",
    ui_login_not_logged_in                  = "PAS IDENTIFIÉ",
    ui_login_please                         = "Pour accéder au système vous devez vous identifier.",
    ui_login_or                             = "OU",
    ui_login_username                       = "Identifiant",
    ui_login_bad_username                   = "Identifiant inconnu.",
    ui_login_bad_username_desc              = "L'identifiant saisi est inconnu de nos bases.",
    ui_login_password                       = "Mot de passe",
    ui_login_bad_password                   = "Mot de passe incorrect.",
    ui_login_bad_password_desc              = "Le mot de passe est incorrect pour ce compte.",
    ui_login_is_government                  = "Est du gouvernement officiel",
    ui_login_bad_is_government              = "Identifiant gouvernemental non trouvé.",
    ui_login_bad_is_government_desc         = "L'accès de ce système est uniquement autorisé pour les personnes habilitées.\nVotre tentative d'accès a été enregistrée et suivie.",
    ui_login_ip                             = "Adresse IP",
    ui_login_established_connect            = "Connexion établie",
    ui_login_bad_established_connect        = "Impossible de se connecter.",
    ui_login_bad_established_connect_desc   = "Impossible de se connecter au système, les services sont momentanément indisponibles.",
    ui_login_proceed                        = "Procéder à la connexion",
    ui_login_proceed_unable                 = "Impossible de procéder à la connexion. Veuillez abandonner.",
    ui_login_show                           = "Afficher plus d'informations.",
    ui_login_abort                          = "Abandonner",

    -- Main connected page.
    ui_connected_logged_in  = "IDENTIFIÉ",
    ui_connected_as_a       = "COMME UN",
    ui_connected_on         = "EN LIGNE",

    -- This is used for the arrests & release records page.
    ui_connected_arrested_by                = "a été arrêté par",
    ui_connected_released_in                = "et sera relâché dans",
    ui_connected_disconnected               = "Déconnecté",
    ui_connected_disconnected_description   = "Ce joueur s'est déconnecté du serveur.",
    ui_connected_profile                    = "Profil",
    ui_connected_jail_empty                 = "Il n'y a actuellement personne en prison.",
    ui_connected_arrested_criminals         = "Criminels actuellement arrêtés",
    ui_connected_was_released               = "a été libéré",
    ui_connected_by                         = "par",
    ui_connected_ago                        = "avant",
    ui_connected_none_recently_released     = "Personne n'a été libéré récemment.",
    ui_connected_recently_released          = "Criminels récemment libérés",
    ui_connected_arrest_release             = "Arrestations et Libérations",
    ui_connected_personal                   = "Informations Personnelles",
    ui_connected_criminal                   = "Casier Judiciaire",
    ui_connected_other                      = "Autre",
    ui_connected_name                       = "Nom",
    ui_connected_age_type                   = "Type d'âge",
    ui_connected_race                       = "Origine",
    ui_connected_height                     = "Taille",
    ui_connected_occupation                 = "Profession",
    ui_connected_health_status              = "État de santé",
    ui_connected_wealth_status              = "Situation économique",
    ui_connected_personal_police            = "Historique personnel",

    -- This is used for the agenda at the home page.
    ui_agenda_edit_agenda       = "Modifier l'agenda",
    ui_agenda_edit_description  = "Quel devrait être le nouvel agenda, %s?",
    ui_agenda_empty             = "Pas d'agenda officiel à l'heure actuelle.",

    -- This is used for the leaderbaorsd at the home page.
    ui_leaderboards_tota_time_spent = "Temps total passé en service:",
    ui_leaderboards_top_10          = "Top 10 des officiers en ligne",
    ui_leaderboards_empty           = "Il n'y a pas d'employé du gouvernement en ligne ou aucune donnée à afficher!",

    -- This is used for the actual home page.
    ui_recent_news      = "Informations récentes",
    ui_no_recent_news   = "Il n'y a pas d'informations à l'heure actuelle.",
    ui_home             = "Accueil",

    -- This is used for the profile at the home page.
    ui_profile_statistics = "Votre profil",

    -- Main page.
    ui_app_home                 = "Accueil",
    ui_app_arrests_and_release  = "Arrestations & Libérations",
    ui_app_wanted_warrants      = "Recherches & Mandats",
    ui_app_licenses             = "Licences",
    ui_app_police               = "Classement au sein de la Police",
    ui_app_statistics           = "Statistiques",
    ui_app_applications         = "Demandes",

    -- Leaderboards page.
    ui_leaderboards_title   = "Classement de la Police",
    ui_viewing_page         = "Page consultée: %i/%i",

    -- Statistics page.

    ui_statistics_kills             = "Crimes";
    ui_statistics_wanted_count      = "Suspects Recherchés";
    ui_statistics_teamkills         = "Crimes Amis";
    ui_statistics_deaths            = "Morts";
    ui_statistics_warranted_count   = "Mandats";
    ui_statistics_confiscated_count = "Confiscations";
    ui_statistics_arrested_count    = "Arrestations";
    ui_statistics_released_count    = "Libérations";
    ui_statistics_ram_count         = "Usages de la force";
    ui_statistics_salary_total      = "Salaire";
    ui_statistics_seconds_on_duty   = "Heures de service";
    ui_statistics_damage_dealt      = "Dégâts infligés";

    -- Notifications
    ui_notification_accept  = "Accepter",
    ui_notification_decline = "Refuser",
    ui_notification_reason_short  = "Keep the reason short",

    -- Database
    ui_database_wipe_police_database        = "Effacer la base de données de la police",
    ui_database_wipe_police_desc            = "Êtes-vous sûr de vouloir effacer la base de données de la police ? Cette action est irréversible. Une fois accepté, cela engendrera un changement de map automatique.",
    ui_database_wipe_criminal_database      = "Effacer la base de données des criminels",
    ui_database_wipe_criminal_database_desc = "Êtes-vous sûr de vouloir effacer la base de données des criminels ? Cette action est irréversible. Une fois accepté, cela engendrera un changement de map automatique.",
    ui_database_wipe_computers              = "Effacer les positions des ordinateurs du gouvernement",
    ui_database_wipe_computers_desc         = "Êtes-vous sûr de vouloir effacer la base de données contenant les positions des ordinateurs du gouvernement ? Cette action est irréversible. Une fois accepté, cela engendrera un changement de map automatique.",
    ui_database_wipe_everything             = "Tout effacer",
    ui_database_wipe_everything_desc        = "Êtes-vous sûr de vouloir tout effacer ? Cette action est irréversible. Une fois accepté, cela engendrera un changement de map automatique.",
    ui_database_are_you_sure                = "Êtes-vous sûr?",
    ui_database                             = "Base de données",

    -- License
    ui_license_occupation                   = "Profession",
    ui_license_has_license                  = "Possède une licence",
    ui_license_yes                          = "Oui",
    ui_license_no                           = "Non",
    ui_licenses                             = "Licences",

    -- Mayor
    ui_mayor_salary                         = "Salaire",
    ui_mayor_demote                         = "Etes vous sûr de vouloir virer %s?",
    ui_mayor_employees                      = "Employés",
    ui_mayor_employees_desc                 = "Vous pouvez virer les personnes en cliquant sur les lignes.",

    ui_mayor_laws                           = "Effacer les lois",
    ui_mayor_reset                          = "Effacer?",
    ui_mayor_are_you_sure                   = "Etes vous sur de vouloir effacer toutes les lois",
    ui_mayor_law_add                        = "Ajouter une loi",
    ui_mayor_law_create                     = "Créer une loi",
    ui_mayor_what                           = "Quelle devrait être cette loi?",
    ui_mayor_change_or                      = "Modifier ou Supprimer?",
    ui_mayor_change_or_decs                 = "Voulez vous changer ou modifier cette loi?",
    ui_mayor_change                         = "Modifier",
    ui_mayor_remove                         = "Supprimer",
    ui_mayor_edit                           = "Modifier la loi: %s",
    ui_mayor_what_change                    = "Qu'aimeriez-vous changer à propos de cette loi?",
    ui_mayor_cant_edit                      = "Pas modifiable",
    ui_mayor_cant_edit_desc                 = "Vous ne pouvez pas modifier cette loi",
    ui_mayor_laws                           = "Lois",

    ui_mayor_lottery_won                    = "a gagné la loterie",
    ui_mayor_lottery_stunning               = "avec un splendide montant de",
    ui_mayor_lottery                        = "Loterie",
    ui_mayor_lottery_desc                   = "Cela montre tous les joueurs qui ont gagné à la loterie et combien ils ont gagné (basé sur la session)",
    ui_mayor_lottery_noone                  = "La loterie n'a pas été remportée, vous pouvez en commencer une maintenant!",

    ui_mayor_taxes_save                     = "Sauvegarder les modifications de taxes",
    ui_mayor_taxes_save_success             = "Succès",
    ui_mayor_taxes_save_success_desc        = "Les taxes ont été modifiées avec succès",

    ui_mayor_taxes_default                  = "Mettre les taxes par défaut",
    ui_mayor_taxes_default_success_desc     = "Les taxes ont été mises par défaut",

    ui_mayor_taxes_default                  = "Désactiver les taxes",
    ui_mayor_taxes_default_success_desc     = "Vous avez désactivé les taxes avec succès",

    ui_mayor_taxes              = "Taxes",
    ui_mayor_taxes_disabled     = "Les taxes sont désactivées",

    ui_mayor_taxes_property     = "Taxes de propriété\n %s%%",
    ui_mayor_taxes_sales        = "Taxes de vente\n %s%%",
    ui_mayor_taxes_salary       = "Taxes des salaires\n %s%%",

    ui_stats_combat         = "Combat",
    ui_stats_general        = "Général",
    ui_stats_other          = "Autre",
    ui_stats_global         = "Statistiques globales du gouvernement",
    ui_stats_together       = "Ces chiffres sont additionnés",

    ui_wanted_noone         = "Pas de personne recherchée à l'heure actuelle.",
    ui_wanted_current       = "Criminels actuellement recherchés",

    ui_warranted_noone      = "Pas de personne perquisitionnée à l'heure actuelle.",
    ui_warranted_current    = "Criminels actuellement perquisitionnés",

    ui_wanted_and_warrants  = "Suspects recherchés & Mandats de perquisition",

    ui_make_wanted          = "Rechercher le suspect",
    ui_remove_wanted        = "Ne plus rechercher",
    ui_make_warrant         = "Appliquer un mandat",
    ui_remove_warrant       = "Supprimer le mandat",
    ui_grant_license        = "Accorder une licence",
    ui_revoke_license       = "Révoquer la licence",
    ui_quick_start_lottery  = "Lancer rapidement la loterie",
    ui_are_you_sure_quick   = "Êtes-vous sûr de vouloir commencer la loterie?",
    ui_select_a_player      = "Sélectionner un joueur pour %s",

    ui_make_wanted_desc     = "Êtes-vous sûr de vouloir rechercher ce joueur?",
    ui_remove_wanted_desc   = "Êtes-vous sûr de vouloir annuler la recherche de ce suspect?",
    ui_make_warrant_desc    = "Êtes-vous sûr de vouloir appliquer un mandat de perquisition sur ce joueur?",
    ui_remove_warrant_desc  = "Êtes-vous sûr de vouloir supprimer le mandat de perquisition de ce joueur?",
    ui_grant_license_desc   = "Êtes-vous sûr de vouloir accorder une licence à ce joueur?",
    ui_revoke_license_desc  = "Êtes-vous sûr de vouloir révoquer la licence de ce joueur?",

    ui_player_disconnect        = "Joueurs déconnectés",
    ui_player_disconnect_desc   = "Ce joueur s'est déconnecté du serveur",

    ui_player_search        = "Rechercher un joueur avec son nom ou son steamid...",
    ui_player_invalid       = "Le joueur sélectionné est invalide",
    ui_player_is_bot        = "Le joueur sélectionné est un bot et ne peut pas être ciblé depuis ce menu",

    ui_create_notes         = "Créer une note",
    ui_add_note             = "Ajouter une note",
    ui_add_note_desc        = "Ajouter une note au profil du joueur pour que les employés du gouvernement puissent la consulter. La note ne pourra pas contenir plus de 300 caractères",
    ui_add_woah             = "Woah",
    ui_add_max              = "La note peut contenir un maximum de 300 caractères, le nombre actuel de caractères est %s",
    ui_add_notes_cd         = "Délais d'attente pour la création d'une note",
    ui_add_note_post_new    = "Vous pouvez faire une nouvelle note dans %s",
    ui_note_title           = "Notes des joueurs",
    ui_note_zero            = "Ce joueur n'a pas de note, vous pouvez en créer une maintenant!",

    -- New after 11.04.2020
    ui_quick_start_lockdown = "Start Lockdown",
    ui_quick_stop_lockdown  = "Stop Lockdown",
    ui_start_lockdown       = "Are you sure you want to start a lockdown?",
    ui_stop_lockdown        = "Are you sure you want to stop the lockdown?",
    ui_lockdown             = "Lockdown",
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

    ui_mayor_salary_disabled                = "The taxes are disabled which means the salaries are disabled, unfortunately.",
    ui_mayor_salary_disabled_noti           = "The taxes are currently disabled which means the salaries are disabled. Enable the taxes by clicking on the 'Manage Taxes' button.",
    ui_mayor_salary_disabled_config         = "Salaries disabled",
    ui_mayor_salary_disabled_config_desc    = "You are unable to manage the salaries because it has been disabled in the config by the server owner.",
    ui_mayor_salary_and_mayor_gets_money    = "Both, 'SublimeGov.Config.MayorCanAdjustSalaries' and 'SublimeGov.Config.MayorGetsMoney' variables are set to true in the config, only one can be enabled at the time. Set one of them to false.",
    ui_mayor_salary_mayor_gets_money        = "Salaries are currently disabled because the tax fund is going straight into the mayors wallet.",
   
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