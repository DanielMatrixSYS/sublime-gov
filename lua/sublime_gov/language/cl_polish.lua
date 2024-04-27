--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeGov.Languages["pl"] = 
{
    this_language = "Polish",

    -- Basic stuff.
    ui_exit = "Wyjdź",
    ui_ok   = "OK",
    ui_no   = "NIE",
    
    -- Login page.
    ui_login_login                          = "Zaloguj",
    ui_login_header                         = "Zabezpieczony system rządowy",
    ui_login_footer                         = "To jest zabezpieczony i monitorowany system rzędu federalnego. Nieautoryzowany dostęp jest surowo zabroniony. Cała aktywność jest w pełni monitorowana.\nOsoby, które próbują uzyskać nieautoryzowany dostęp lub próbują dokonać modyfikacji informacji w tym systemie podlegają postępowaniu karnemu.\nWszystkie osoby które zostają niniejszym powiadomione że korzystanie z tego systemu stanowi monitorowanie i rewizję.",
    ui_login_title                          = "Sublime Government - ",
    ui_login_not_logged_in                  = "NIE ZALOGOWANO",
    ui_login_please                         = "Aby uzyskać dostęp do systemu musisz się zalogować",
    ui_login_or                             = "ALBO",
    ui_login_username                       = "Nazwa użytkownika",
    ui_login_bad_username                   = "Nazwa użytkownika nie rozpoznana.",
    ui_login_bad_username_desc              = "Wpisana nazwa użytkownika nie jest rozpoznana w systemie.",
    ui_login_password                       = "Hasło",
    ui_login_bad_password                   = "Niepoprawne hasło.",
    ui_login_bad_password_desc              = "Hasło powiązane z tym kontem jest niepoprawne",
    ui_login_is_government                  = "Jest urzędnikiem państwowym",
    ui_login_bad_is_government              = "Rządowe ID nie znalezione.",
    ui_login_bad_is_government_desc         = "Tylko oficjalni pracownicy rządowi mogą uzyskać dostęp do tego systemu. \nTwoja obecność została zarejestrowana",
    ui_login_ip                             = "Adres IP",
    ui_login_established_connect            = "Połączenie Nawiązane",
    ui_login_bad_established_connect        = "Nie można połączyć.",
    ui_login_bad_established_connect_desc   = "Nie można połączyć z systemem, wygląda na to że teraz nie działa.",
    ui_login_proceed                        = "Kontynuuj połączenie",
    ui_login_proceed_unable                 = "Nie można kontynuować połączenia. Proszę przerwać.",
    ui_login_show                           = "Wyświetl więcej informacji.",
    ui_login_abort                          = "Przerwij",

    -- Main connected page.
    ui_connected_logged_in  = "ZALOGOWANO",
    ui_connected_as_a       = "JAKO",
    ui_connected_on         = "NA",

    -- This is used for the arrests & release records page.
    ui_connected_arrested_by                = "został aresztowany przez",
    ui_connected_released_in                = "i będzie uwolniony za",
    ui_connected_disconnected               = "Rozłączono",
    ui_connected_disconnected_description   = "Ten gracz rozłączył się z serwerem.",
    ui_connected_profile                    = "'s Profil",
    ui_connected_jail_empty                 = "Obecnie nie ma nikogo w więzieniu.",
    ui_connected_arrested_criminals         = "Obecnie aresztowani przestępcy",
    ui_connected_was_released               = "został uwolniony",
    ui_connected_by                         = "przez",
    ui_connected_ago                        = "temu",
    ui_connected_none_recently_released     = "Nikt nie został ostatnio uwolniony.",
    ui_connected_recently_released          = "Ostatnio uwolnieni przestępcy",
    ui_connected_arrest_release             = "Zaaresztuj & Uwolnij",
    ui_connected_personal                   = "Informacje osobiste",
    ui_connected_criminal                   = "Kronika kryminalna",
    ui_connected_other                      = "Inne",
    ui_connected_name                       = "Imię",
    ui_connected_age_type                   = "Typ Wieku",
    ui_connected_race                       = "Rasa",
    ui_connected_height                     = "Wysokość",
    ui_connected_occupation                 = "Zawód",
    ui_connected_health_status              = "Stan Zdrowia",
    ui_connected_wealth_status              = "Status majątkowy",
    ui_connected_personal_police            = "Dokumentacja policyjna",

    -- This is used for the agenda at the home page.
    ui_agenda_edit_agenda       = "Edytuj program",
    ui_agenda_edit_description  = "Jaki powinien być nowy, oficjalny program, %s?",
    ui_agenda_empty             = "Jeszcze nie ma oficjalnego programu.",

    -- This is used for the leaderbaorsd at the home page.
    ui_leaderboards_tota_time_spent = "Czas spędzony na służbie:",
    ui_leaderboards_top_10          = "Top 10 Aktywnych Oficerów",
    ui_leaderboards_empty           = "Nie ma pracowników rządowych online lub nie ma danych do wyświetlenia!",

    -- This is used for the actual home page.
    ui_recent_news      = "Ostatnie wiadomości",
    ui_no_recent_news   = "Nie ma ostatnich wiadomości.",
    ui_home             = "Dom",

    -- This is used for the profile at the home page.
    ui_profile_statistics = "Twój profil",

    -- Main page.
    ui_app_home                 = "Dom",
    ui_app_arrests_and_release  = "Aresztowania & Uwolnienia",
    ui_app_wanted_warrants      = "Poszukiwania & Nakazy",
    ui_app_licenses             = "Licencje",
    ui_app_police               = "Tabela wyników policji",
    ui_app_statistics           = "Statystyki",
    ui_app_applications         = "A",
	
	ui_app_main_apps                        = "Główne Aplikacje",
	
	ui_app_mayor                            = "Burmistrz",
    ui_app_mayor_employees                  = "Zarządzaj Pracownikami",
    ui_app_mayor_lottery                    = "Zarządzaj Loteriami",
    ui_app_mayor_laws                       = "Zarządzaj Prawami",
    ui_app_mayor_salaries                   = "Zarządzaj Wypłatami",
    ui_app_mayor_taxes                      = "Zarządzaj Podatkami",
    ui_app_mayor_taxes_disabled             = "Podatki są wyłączone",
    ui_app_mayor_taxes_disabled_desc        = "Podatki są obecnie wyłączone, chcesz je włączyć?",
    ui_app_mayor_taxes_disabled_admin_desc  = "Podatki są wyłączone i nie mogą być włączone ponieważ własciciel serwera je wyłączył. Jeżeli jesteś włascicielem serwera zajrzyj do pliku konfiguracyjnego!",
	
	ui_app_admin                            = "Admin Settings",
    ui_app_admin_database                   = "Baze danych",
    ui_app_admin_credits                    = "Przypisy",
    ui_app_exit                             = "Wyjdź",

    -- Leaderboards page.
    ui_leaderboards_title   = "Tabela wyników policji",
    ui_viewing_page         = "Wyświetlanie strony: %i/%i",

    -- Statistics page.

    ui_statistics_kills             = "Zabójstwa";
    ui_statistics_wanted_count      = "Poszukiwania";
    ui_statistics_teamkills         = "Zabójstwa drużynowe";
    ui_statistics_deaths            = "Śmierci";
    ui_statistics_warranted_count   = "Nakazy sądowe";
    ui_statistics_confiscated_count = "Skonfiskowane";
    ui_statistics_arrested_count    = "Areszty";
    ui_statistics_released_count    = "Uwolnienia";
    ui_statistics_ram_count         = "Staranowania";
    ui_statistics_salary_total      = "Wynagrodzenie";
    ui_statistics_seconds_on_duty   = "Godziny dyżuru";
    ui_statistics_damage_dealt      = "Zadane obrażenia";

    -- Notifications
    ui_notification_accept  = "Akceptuj",
    ui_notification_decline = "Odrzuć",
    ui_notification_reason_short  = "Keep the reason short",

    -- Database
    ui_database_wipe_police_database        = "Wyczyść bazę danych policji",
    ui_database_wipe_police_desc            = "Czy na pewno chcesz wyczyścić bazę danych policji? To nie może być cofnięte. Po zaakceptowaniu mapa zostanie automatycznie zmieniona.",
    ui_database_wipe_criminal_database      = "Wyczyść bazę danych kryminalistów",
    ui_database_wipe_criminal_database_desc = "Czy na pewno chcesz wyczyścić bazę danych kryminalistów? To nie może być cofnięte. Po zaakceptowaniu mapa zostanie automatycznie zmieniona.",
    ui_database_wipe_computers              = "Wyczyść Pozycje Komputerów Rządowych",
    ui_database_wipe_computers_desc         = "Czy na pewno chcesz wyczyścić pozycje komputerów rządowych? To nie może być cofnięte. Po zaakceptowaniu mapa zostanie automatycznie zmieniona.",
    ui_database_wipe_everything             = "Wyczyść wszystko",
    ui_database_wipe_everything_desc        = "Czy na pewno chcesz wyczyścić wszystko? To nie może być cofnięte. Po zaakceptowaniu mapa zostanie automatycznie zmieniona.",
    ui_database_are_you_sure                = "Jesteś pewien?",
    ui_database                             = "Baza danych",

    -- License
    ui_license_occupation                   = "Zawód",
    ui_license_has_license                  = "Ma Licencję",
    ui_license_yes                          = "Tak",
    ui_license_no                           = "Nie",
    ui_licenses                             = "Licencje",

    -- Mayor
    ui_mayor_salary                         = "Wynagrodzenie",
    ui_mayor_demote                         = "Na pewno chcesz wymusić degradację na %s?",
    ui_mayor_employees                      = "Pracownicy",
    ui_mayor_employees_desc                 = "Możesz degradować ludzi poprzez kliknięcie na jeden z rządów.",

    ui_mayor_laws_reset_laws                = "Zresetuj prawa",
    ui_mayor_reset                          = "Zresetować?",
    ui_mayor_are_you_sure                   = "Czy na pewno chcesz zresetować wszystkie prawa?",
    ui_mayor_law_add                        = "Dodaj Prawo",
    ui_mayor_law_create                     = "Stwórz Prawo",
    ui_mayor_what                           = "Jakie powinno być to prawo?",
    ui_mayor_change_or                      = "Zmienić czy usunąć?",
    ui_mayor_change_or_decs                 = "Czy chcesz zmienić czy usunąć to prawo?",
    ui_mayor_change                         = "Zmień",
    ui_mayor_remove                         = "Usuń",
    ui_mayor_edit                           = "Zmienić prawo: %s",
    ui_mayor_what_change                    = "Co chciałbyś zmienić w tym prawie?",
    ui_mayor_cant_edit                      = "Nie można zmienić",
    ui_mayor_cant_edit_desc                 = "Nie możesz zmienić tego prawa",
    ui_mayor_laws                           = "Lista Praw",

    ui_mayor_lottery_won                    = "wygrał loterię",
    ui_mayor_lottery_stunning               = "Z oszałamiającą sumą",
    ui_mayor_lottery                        = "Loterie",
    ui_mayor_lottery_desc                   = "To wyświetla wszystkich graczy którzy wygrali loterię oraz ile wygrali(Na podstawie sesji)",
    ui_mayor_lottery_noone                  = "Nikt jeszcze nie wygrał loterii, zacznij jedną teraz!",

    ui_mayor_taxes_save                     = "Zapisz zmiany podatkowe",
    ui_mayor_taxes_save_success             = "Sukces",
    ui_mayor_taxes_save_success_desc        = "Podatki pomyślnie zmienione",

    ui_mayor_taxes_default                  = "Zmień Na Domyślne",
    ui_mayor_taxes_default_success_desc     = "Podatki zostały zresetowane do wartości domyślnych",

    ui_mayor_taxes_disable                  = "Wyłącz podatki",
    ui_mayor_taxes_disable_success_desc     = "Pomyślnie wyłączyłeś system podatków",

    ui_mayor_taxes              = "Podatki",
    ui_mayor_taxes_disabled     = "Podatki są wyłączone",

    ui_mayor_taxes_property     = "Podatek własnościowy\n %s%%",
    ui_mayor_taxes_sales        = "Podatek od sprzedarzy\n %s%%",
    ui_mayor_taxes_salary       = "Podatek od wynagrodzeń\n %s%%",

    ui_stats_combat         = "Walka",
    ui_stats_general        = "Ogólne",
    ui_stats_other          = "Inne",
    ui_stats_global         = "Globalne Statystyki Rządowe",
    ui_stats_together       = "Te liczby są sumowane",

    ui_wanted_noone         = "Nikt nie jest obecnie poszukiwany.",
    ui_wanted_current       = "Obecnie poszukiwani przestępcy",

    ui_warranted_noone      = "Nikt nie jest obecnie pod nakazem sądowym",
    ui_warranted_current    = "Obecni kryminaliści pod nakazem rządowym",

    ui_wanted_and_warrants  = "Poszukiwania & Nakazy Przeszukiwań",

    ui_make_wanted          = "Ustaw Poszukiwanie",
    ui_remove_wanted        = "Usuń Poszukiwanie",
    ui_make_warrant         = "Ust Nakaz Przeszk",
    ui_remove_warrant       = "Usuń Nakaz Przeszk",
    ui_grant_license        = "Daj Licencję",
    ui_revoke_license       = "Zabierz Licencję",
    ui_quick_start_lottery  = "Zacznij Szybką Loterie",
    ui_are_you_sure_quick   = "Czy na pewno chcesz rozpocząć szybką loterię?",
    ui_select_a_player      = "Wybierz gracza aby %s",

    ui_make_wanted_desc     = "Czy na pewno chcesz szybko poszukiwać tego gracza?",
    ui_remove_wanted_desc   = "Czy na pewno chcesz szybko usunąć poziom poszukiwania tego gracza?",
    ui_make_warrant_desc    = "Czy na pewno chcesz szybko nakazać przeszukiwanie tego gracza?",
    ui_remove_warrant_desc  = "Czy na pewno chcesz szybko usunąć nakaz przeszukiwania tego gracza?",
    ui_grant_license_desc   = "Czy na pewno chcesz dać temu graczowi licencję na broń?",
    ui_revoke_license_desc  = "Czy na pewno chcesz zabrać temu graczowi licencję na broń?",

    ui_player_disconnect        = "Gracz Rozłączony",
    ui_player_disconnect_desc   = "Ten gracz rozłączył się z serwerem",

    ui_player_search        = "Szukaj steamid i nazw graczy...",
    ui_player_invalid       = "Wybrany Niepoprawny Gracz",
    ui_player_is_bot        = "Wybrany gracz jest botem i nie może być wybrany z tego menu",

    ui_create_notes         = "Stwórz Notatkę",
    ui_add_note             = "Dodaj Notatkę",
    ui_add_note_desc        = "Dodaj małą notatkę na profil tego gracza dla innych pracowników rządowych.",
    ui_add_woah             = "Łał",
    ui_add_max              = "Notatki mogą mieć tylko 300 liter, twoja obecnie ma %s",
    ui_add_notes_cd         = "Czas Odnowienia Notatek",
    ui_add_note_post_new    = "Możesz umieścić nowa notatkę w %s",
    ui_note_title           = "Notatki Gracza",
    ui_note_zero            = "Ten gracz nie ma żadnych notatek, stwórz jedną teraz!",

    ui_mayor_salary_disabled                = "Niestety, podatki są wyłączone co oznacza że wypłaty są wyłączone.",
    ui_mayor_salary_disabled_noti           = "Niestety, podatki są wyłączone co oznacza że wypłaty są wyłączone. Włącz podatki poprzez naciśnięcie przycisku 'Zarządzanie podatkami'.",
    ui_mayor_salary_disabled_config         = "Wypłaty wyłączone",
    ui_mayor_salary_disabled_config_desc    = "Nie możesz zarządzać wypłatami poniewawż zostało to wyłączone w konfiguracji przez właściciela serwera.",
    ui_mayor_salary_and_mayor_gets_money    = "Obydwa, 'SublimeGov.Config.MayorCanAdjustSalaries' i 'SublimeGov.Config.MayorGetsMoney' są ustawione na true w konfiguracji, tylko jedno może być włączone na raz. Ustaw jedno z nich na false.",
    ui_mayor_salary_mayor_gets_money        = "Wypłaty są obecnie wyłączone ponieważ fundusz podatkowy idzie prosto do portfela prezydenta.",
   
    ui_mayor_tax_fund = "Fundusz podatkowy: %s",

    tool_spawn      = "Lewy spawnuje.",
    tool_delete     = "Prawy usuwa.",
    tool_save       = "Reload zapisuje",

    ui_mayor_taxes_change_dis   = "Wyłącz dodatkową wypłatę",
    ui_mayor_taxes_change_ena   = "Włącz dodatkową wypłatę",

    ui_mayor_taxes_change_dis_desc  = "Dodatkowa wypłata włączona.",
    ui_mayor_taxes_change_ena_desc  = "Dodatkowa wypłata włączona.",

        -- These are used after you select a playere for a wanted, warrant, or whatever.
        ui_connected_wanted_title = "Wanted Reason",
        ui_connected_wanted_reason = "Reasoning for making %s wanted?",
        ui_connected_warrant_title = "Warrant Reason",
        ui_connected_warrant_reason = "Reasoning for making %s warranted?",
}