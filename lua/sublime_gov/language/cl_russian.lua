--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------
 
SublimeGov.Languages["ru"] =
{
    this_language = "Русский",
 
    -- Basic stuff.
    ui_exit = "Выход",
    ui_ok   = "OK",
    ui_no   = "NO",
   
    -- Login page.
    ui_login_login                          = "Логин",
    ui_login_header                         = "Система государственного управления",
    ui_login_footer                         = "Это защищенная и контролируемая система федерального правительства. Несанкционированный доступ строго запрещен. Вся деятельность полностью контролируется. \n NИндивидуальные лица, которые пытаются получить несанкционированный доступ или пытаются модифицировать информацию в этой системе, подлежат уголовному преследованию. \n NВсе лица, уведомленные о том, что использование этой системы представляет собой мониторинг и аудит.",
    ui_login_title                          = "Возвышенное правительство - ",
    ui_login_not_logged_in                  = "НЕ ВОШЕЛ",
    ui_login_please                         = "Для доступа к системе вам необходимо войти в систему.",
    ui_login_or                             = "ИЛИ",
    ui_login_username                       = "имя пользователя",
    ui_login_bad_username                   = "Имя пользователя не распознано.",
    ui_login_bad_username_desc              = "Введенное имя пользователя не распознается в нашей системе.",
    ui_login_password                       = "Пароль",
    ui_login_bad_password                   = "неверный пароль.",
    ui_login_bad_password_desc              = "Пароль, связанный с этой учетной записью, неверен.",
    ui_login_is_government                  = "Правительственный чиновник",
    ui_login_bad_is_government              = "Удостоверение личности правительства не найдено.",
    ui_login_bad_is_government_desc         = "Только официальные государственные служащие могут получить доступ к этой системе. Ваше присутствие было зарегистрировано.",
    ui_login_ip                             = "Айпи адрес",
    ui_login_established_connect            = "Соединение установлено",
    ui_login_bad_established_connect        = "Невозможно подключиться.",
    ui_login_bad_established_connect_desc   = "Невозможно подключиться к системе, похоже, в данный момент не работает.",
    ui_login_proceed                        = "Продолжить соединение",
    ui_login_proceed_unable                 = "Невозможно продолжить соединение. Пожалуйста прервите.",
    ui_login_show                           = "Показать больше информации.",
    ui_login_abort                          = "Прервать",
 
    -- Main connected page.
    ui_connected_logged_in  = "ВОЙТИ В",
    ui_connected_as_a       = "КАК",
    ui_connected_on         = "НА",
 
    -- This is used for the arrests & release records page.
    ui_connected_arrested_by                = "был арестован",
    ui_connected_released_in                = "и будет выпущен в",
    ui_connected_disconnected               = "Отключился",
    ui_connected_disconnected_description   = "Этот игрок отключился от сервера.",
    ui_connected_profile                    = "профиль",
    ui_connected_jail_empty                 = "В настоящее время в тюрьме никого нет.",
    ui_connected_arrested_criminals         = "В настоящее время арестованы преступники",
    ui_connected_was_released               = "был выпущен",
    ui_connected_by                         = "по",
    ui_connected_ago                        = "тому назад",
    ui_connected_none_recently_released     = "Никто не был недавно освобожден.",
    ui_connected_recently_released          = "Недавно освобожденные преступники",
    ui_connected_arrest_release             = "Арест и освобождение",
    ui_connected_personal                   = "Личные данные",
    ui_connected_criminal                   = "Судимости",
    ui_connected_other                      = "Другое",
    ui_connected_name                       = "Имя",
    ui_connected_age_type                   = "Возраст тип",
    ui_connected_race                       = "Раса",
    ui_connected_height                     = "Рост",
    ui_connected_occupation                 = "профессия",
    ui_connected_health_status              = "Состояние здоровья",
    ui_connected_wealth_status              = "Состояние богатства",
    ui_connected_personal_police            = "Полицейская запись",
 
    -- This is used for the agenda at the home page.
    ui_agenda_edit_agenda       = "Изменить повестку дня",
    ui_agenda_edit_description  = "Какой должна быть новая повестка дня?, %s?",
    ui_agenda_empty             = "Официальной повестки дня пока нет.",
 
    -- This is used for the leaderbaorsd at the home page.
    ui_leaderboards_tota_time_spent = "Общее время, проведенное на дежурстве:",
    ui_leaderboards_top_10          = "Топ 10 офицеров онлайн",
    ui_leaderboards_empty           = "В сети либо нет государственных служащих, либо нет данных для отображения!",
 
    -- This is used for the actual home page.
    ui_recent_news      = "Свежие новости",
    ui_no_recent_news   = "Нет последних новостей.",
    ui_home             = "Дом",
 
    -- This is used for the profile at the home page.
    ui_profile_statistics = "Your profile",
 
    -- Main page.
    ui_app_home                 = "Дом",
    ui_app_arrests_and_release  = "Аресты и Освобождение",
    ui_app_wanted_warrants      = "Розыск и ордер",
    ui_app_licenses             = "Лицензии",
    ui_app_police               = "Таблицы лидеров полиции",
    ui_app_statistics           = "Статистика",
    ui_app_applications         = "Приложения",
 
    -- Leaderboards page.
    ui_leaderboards_title   = "Полицейские таблицы лидеров",
    ui_viewing_page         = "Страница просмотра: %i/%i",
 
    -- Statistics page.
 
    ui_statistics_kills             = "Убийств";
    ui_statistics_wanted_count      = "Разыскивается";
    ui_statistics_teamkills         = "Убийство своих";
    ui_statistics_deaths            = "Смертей";
    ui_statistics_warranted_count   = "Ордеров";
    ui_statistics_confiscated_count = "Конфисковано";
    ui_statistics_arrested_count    = "Арестов";
    ui_statistics_released_count    = "Выпущены";
    ui_statistics_ram_count         = "Таран";
    ui_statistics_salary_total      = "Зарплата";
    ui_statistics_seconds_on_duty   = "Часов на работе";
    ui_statistics_damage_dealt      = "Нанесенный ущерб";
 
    -- Notifications
    ui_notification_accept  = "Принять",
    ui_notification_decline = "Отклонить",
    ui_notification_reason_short  = "Keep the reason short",
    
    -- Database
    ui_database_wipe_police_database        = "Очистить базу данных полиции",
    ui_database_wipe_police_desc            = "Вы уверены, что хотите сбросить базу данных полиции? Это не может быть отменено. Автоматическое изменение карты будет выдано после принятия.",
    ui_database_wipe_criminal_database      = "Очистить криминальную базу данных",
    ui_database_wipe_criminal_database_desc = "Вы уверены, что хотите сбросить криминальную базу данных? Это не может быть отменено. Автоматическое изменение карты будет выдано после принятия.",
    ui_database_wipe_computers              = "Очистить правительственные компьютерные позиции",
    ui_database_wipe_computers_desc         = "Вы уверены, что хотите сбросить правительственные компьютерные позиции? Это не может быть отменено. Автоматическое изменение карты будет выдано после принятия.",
    ui_database_wipe_everything             = "Очистить всё",
    ui_database_wipe_everything_desc        = "Вы уверены, что хотите сбросить все? Это не может быть отменено. Автоматическое изменение карты будет выдано после принятия.",
    ui_database_are_you_sure                = "Вы уверены?",
    ui_database                             = "База данных",
 
    -- License
    ui_license_occupation                   = "Занятие",
    ui_license_has_license                  = "Имеет лицензию",
    ui_license_yes                          = "Да",
    ui_license_no                           = "Нет",
    ui_licenses                             = "Лицензия",
 
    -- Mayor
    ui_mayor_salary                         = "Зарплата",
    ui_mayor_demote                         = "Вы уверены что хотите понизить %s?",
    ui_mayor_employees                      = "Сотрудники",
    ui_mayor_employees_desc                 = "Вы можете понизить людей, нажав на одну из строк.",
 
    ui_mayor_laws_reset_laws                = "Сбросить законы",
    ui_mayor_reset                          = "Сбросить?",
    ui_mayor_are_you_sure                   = "Вы уверены, что хотите сбросить каждый закон?",
    ui_mayor_law_add                        = "Добавить закон",
    ui_mayor_law_create                     = "Создать закон",
    ui_mayor_what                           = "Каким должен быть этот закон?",
    ui_mayor_change_or                      = "Изменить или удалить?",
    ui_mayor_change_or_decs                 = "Вы хотите изменить или удалить этот закон?",
    ui_mayor_change                         = "Изменить",
    ui_mayor_remove                         = "Удалить",
    ui_mayor_edit                           = "Изменить закон: %s",
    ui_mayor_what_change                    = "Что бы вы хотели изменить в этом законе?",
    ui_mayor_cant_edit                      = "Не могу редактировать",
    ui_mayor_cant_edit_desc                 = "Вы не можете редактировать этот закон ",
    ui_mayor_laws                           = "Законы",
 
    ui_mayor_lottery_won                    = "выиграл в лотереи",
    ui_mayor_lottery_stunning               = "С потрясающим количеством",
    ui_mayor_lottery                        = "лотерея",
    ui_mayor_lottery_desc                   = "Это показывает всех игроков, которые выиграли в лотерею, и сколько они заработали (на основе сеанса)",
    ui_mayor_lottery_noone                  = "Никто еще не выиграл в лотерею, начните ее сейчас!",
 
    ui_mayor_taxes_save                     = "Сохранить налоговые изменения",
    ui_mayor_taxes_save_success             = "успех",
    ui_mayor_taxes_save_success_desc        = "Налоги успешно изменены",
 
    ui_mayor_taxes_default                  = "Изменить на значение по умолчанию",
    ui_mayor_taxes_default_success_desc     = "Налоги были сброшены по умолчанию",
 
    ui_mayor_taxes_disable                  = "Отключить налоги",
    ui_mayor_taxes_disable_success_desc     = "Вы успешно отключили систему налогообложения",
 
    ui_mayor_taxes              = "Налоги",
    ui_mayor_taxes_disabled     = "Налоги отключены",
 
    ui_mayor_taxes_property     = "Налог на имущество %s%%",
    ui_mayor_taxes_sales        = "Налог на продажу %s%%",
    ui_mayor_taxes_salary       = "Налог на зарплату %s%%",
 
    ui_stats_combat         = "Бой",
    ui_stats_general        = "Главный",
    ui_stats_other          = "Другое",
    ui_stats_global         = "Статистика мирового правительства",
    ui_stats_together       = "Эти числа складываются вместе",
 
    ui_wanted_noone         = "Никто в настоящее время не разыскивается.",
    ui_wanted_current       = "В настоящее время разыскиваются преступники",
 
    ui_warranted_noone      = "Нету ордеров.",
    ui_warranted_current    = "В настоящие ордеров на преступников ",
 
    ui_wanted_and_warrants  = "Розыск & Ордеры",
 
    ui_make_wanted          = "Выдать розыск",
    ui_remove_wanted        = "Убрать розыск",
    ui_make_warrant         = "Выдать ордер",
    ui_remove_warrant       = "Забрать ордер",
    ui_grant_license        = "Предоставить лицензию",
    ui_revoke_license       = "Отзыв лицензии",
    ui_quick_start_lottery  = "Быстрый старт лотереи",
    ui_are_you_sure_quick   = "Вы уверены, что хотите быстро начать лотерею?",
    ui_select_a_player      = "Выберите игрока для %s",
 
    ui_make_wanted_desc     = "Вы уверены, что хотите быстро быстро выдать розыск?",
    ui_remove_wanted_desc   = "Вы уверены, что хотите быстро убрать розыск игрока?",
    ui_make_warrant_desc    = "Вы уверены, что хотите быстро выдать розыск этому игроку?",
    ui_remove_warrant_desc  = "Вы уверены, что хотите быстро удалить этот ордер у игроков?",
    ui_grant_license_desc   = "Вы уверены, что хотите дать этому игроку лицензию на оружие?",
    ui_revoke_license_desc  = "Вы уверены, что хотите отозвать лицензию на оружие?",
 
    ui_player_disconnect        = "Игрок отключен",
    ui_player_disconnect_desc   = "Этот игрок отключился от сервера",
 
    ui_player_search        = "Поиск имен игроков и steamids...",
    ui_player_invalid       = "Выбран неверный игрок",
    ui_player_is_bot        = "Выбранный игрок бот и не может быть целью из этого меню",
 
    ui_create_notes         = "Создать заметку",
    ui_add_note             = "Добавить заметку",
    ui_add_note_desc        = "Добавьте небольшую заметку в профиль этого игрока, чтобы ее могли увидеть другие государственные служащие. Примечание может содержать только 300 символов",
    ui_add_woah             = "Woah",
    ui_add_max              = "Заметки могут содержать не более 300 символов, в настоящее время у вас %s",
    ui_add_notes_cd         = "Перезарядка Заметки",
    ui_add_note_post_new    = "Вы можете опубликовать новую заметку в %s",
    ui_note_title           = "Примечания игрока",
    ui_note_zero            = "У этого игрока нет заметок, создайте его сейчас!",

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