// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Денежно';

  @override
  String get home => 'Главная';

  @override
  String get accounts => 'Счета';

  @override
  String get transactions => 'Операции';

  @override
  String get payments => 'Платежи';

  @override
  String get forecast => 'Прогноз';

  @override
  String get settings => 'Настройки';

  @override
  String get welcome => 'Ваши финансы — под рукой';

  @override
  String get homeEmpty =>
      'Здесь появится обзор ваших денег, расходов и ближайших платежей.';

  @override
  String get accountsEmpty => 'Здесь будут ваши счета и их остатки.';

  @override
  String get transactionsEmpty =>
      'Здесь будет история доходов, расходов и переводов.';

  @override
  String get paymentsEmpty => 'Здесь будут обязательные платежи и напоминания.';

  @override
  String get forecastEmpty => 'Здесь появится прогноз доступных средств.';

  @override
  String get notAvailableYet => 'Учёт финансов пока недоступен.';

  @override
  String get appearance => 'Оформление';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлое';

  @override
  String get themeDark => 'Тёмное';

  @override
  String get storage => 'Хранение';

  @override
  String get storageOpening => 'Открываем защищённое хранилище…';

  @override
  String get storageReady => 'Настройки сохраняются на этом устройстве.';

  @override
  String get storagePaused => 'Хранилище закрыто до возвращения в приложение.';

  @override
  String get storageError =>
      'Защищённое хранилище недоступно. Существующие данные сохранены. Разблокируйте устройство и повторите попытку.';

  @override
  String get retry => 'Повторить';

  @override
  String get syncUnavailable => 'Синхронизация пока недоступна.';

  @override
  String get selectedTheme => 'Выбранное оформление';

  @override
  String get diagnostics => 'Диагностика';

  @override
  String get diagnosticsHint =>
      'Техническая сводка без ключей, путей и ваших данных. Её можно скопировать и отправить разработчику.';

  @override
  String get copyDiagnostics => 'Скопировать диагностику';

  @override
  String get diagnosticsCopied => 'Диагностика скопирована.';

  @override
  String get diagnosticsCopyFailed => 'Не удалось скопировать диагностику.';

  @override
  String get addAccount => 'Добавить счёт';

  @override
  String get updateBalances => 'Обновить остатки';

  @override
  String get accountsEmptyTitle => 'Пока нет счетов';

  @override
  String get accountsEmptyHint =>
      'Добавьте карты, наличные, накопления, кредитки и кредиты — так приложение увидит все ваши деньги и долги.';

  @override
  String get accountsStorageClosed =>
      'Счета появятся, когда откроется защищённое хранилище.';

  @override
  String get accountsLoadFailed =>
      'Не удалось загрузить счета. Данные не изменены.';

  @override
  String get groupMoney => 'Деньги';

  @override
  String get groupSavings => 'Накопления';

  @override
  String get groupDebts => 'Долги';

  @override
  String get totalOwnMoney => 'Свои деньги';

  @override
  String get kindDebit => 'Дебетовая карта';

  @override
  String get kindCash => 'Наличные';

  @override
  String get kindSavings => 'Накопительный счёт';

  @override
  String get kindDeposit => 'Вклад';

  @override
  String get kindCreditCard => 'Кредитная карта';

  @override
  String get kindLoan => 'Кредит';

  @override
  String get updatedToday => 'обновлено сегодня';

  @override
  String get updatedYesterday => 'обновлено вчера';

  @override
  String updatedDaysAgo(int days) {
    return 'обновлено $days дн. назад';
  }

  @override
  String creditLimitValue(String amount) {
    return 'лимит $amount';
  }

  @override
  String get accountKind => 'Тип';

  @override
  String get fieldName => 'Название';

  @override
  String get fieldAmountAsset => 'Сколько сейчас на счёте';

  @override
  String get fieldAmountCard => 'Сколько сейчас должны банку';

  @override
  String get fieldAmountLoan => 'Сколько осталось выплатить';

  @override
  String get fieldCreditLimit => 'Кредитный лимит (необязательно)';

  @override
  String get protectedLabel => 'Не трогать';

  @override
  String get protectedHint =>
      'Не учитывать в «можно потратить» — для накоплений.';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get invalidAmount => 'Введите сумму, например 12 345,67';

  @override
  String get nameRequired => 'Введите название';

  @override
  String get saveFailed => 'Не удалось сохранить. Данные не изменены.';

  @override
  String get unchanged => 'Не изменилось';

  @override
  String currentAmount(String amount) {
    return 'сейчас $amount';
  }

  @override
  String get updateHint =>
      'Откройте приложения банков и впишите текущие суммы. Если сумма не изменилась — нажмите «Не изменилось». Пустые поля не меняются.';

  @override
  String updateResultExpenses(String amount) {
    return 'Остатки обновлены. Неучтённые расходы: $amount';
  }

  @override
  String updateResultIncome(String amount) {
    return 'Остатки обновлены. Неучтённые поступления: $amount';
  }

  @override
  String get updateResultNone => 'Остатки обновлены.';

  @override
  String get upcomingTitle => 'Ближайшие 30 дней';

  @override
  String get upcomingEmpty =>
      'Здесь появятся ближайшие платежи и поступления. Добавьте регулярный платёж, зарплату или цифры кредитки.';

  @override
  String get creditCardsTitle => 'Кредитки: цифры банка';

  @override
  String get cardNoFigures => 'Внесите цифры из приложения банка';

  @override
  String cardGraceLine(String amount, String date) {
    return 'Чтобы не платить проценты: $amount до $date';
  }

  @override
  String cardMinLine(String amount, String date) {
    return 'Минимальный платёж: $amount до $date';
  }

  @override
  String get cardMinOnly =>
      'минимальный платёж — сумма для льготного периода не указана';

  @override
  String get cardSettled => 'внесено';

  @override
  String get recurringTitle => 'Регулярные платежи';

  @override
  String get incomesTitle => 'Доходы';

  @override
  String get addPayment => 'Добавить платёж';

  @override
  String get addIncome => 'Добавить доход';

  @override
  String get paymentTitle => 'Платёж';

  @override
  String get incomeTitle => 'Доходы';

  @override
  String get delete => 'Удалить';

  @override
  String get markPaid => 'Оплачено';

  @override
  String get markReceived => 'Получено';

  @override
  String get markDone => 'Сделано';

  @override
  String get undoMark => 'Отменить отметку';

  @override
  String get dueToday => 'сегодня';

  @override
  String get dueTomorrow => 'завтра';

  @override
  String get flowKindSalary => 'Зарплата';

  @override
  String get flowKindOtherIncome => 'Другой доход';

  @override
  String get flowKindSubscription => 'Подписка';

  @override
  String get flowKindUtilities => 'Коммунальные';

  @override
  String get flowKindLoanPayment => 'Платёж по кредиту';

  @override
  String get flowKindRent => 'Аренда';

  @override
  String get flowKindCommunication => 'Связь и интернет';

  @override
  String get flowKindOtherPayment => 'Другое';

  @override
  String get cadenceMonthly => 'Каждый месяц';

  @override
  String get cadenceWeekly => 'Каждую неделю';

  @override
  String get cadenceYearly => 'Каждый год';

  @override
  String get cadenceOnce => 'Один раз';

  @override
  String monthlyOn(int day) {
    return '$day-го числа каждый месяц';
  }

  @override
  String weeklyOn(String weekday) {
    return 'каждую неделю: $weekday';
  }

  @override
  String yearlyOn(String date) {
    return '$date каждый год';
  }

  @override
  String onceOn(String date) {
    return '$date, один раз';
  }

  @override
  String get fieldKind => 'Вид';

  @override
  String get fieldAmount => 'Сумма';

  @override
  String get fieldSchedule => 'Когда';

  @override
  String get chooseDate => 'Выбрать';

  @override
  String get graceAmountField => 'Внести, чтобы не платить проценты';

  @override
  String get minPaymentField => 'Минимальный платёж';

  @override
  String get dueDateField => 'До какого числа';

  @override
  String get cardFiguresHint =>
      'Перепишите цифры с экрана кредитки в приложении банка. Цифры банка главные — мы их не пересчитываем. Можно указать только одну из сумм.';

  @override
  String get figuresNeedOne => 'Укажите хотя бы одну сумму';

  @override
  String get settleCard => 'Внёс';

  @override
  String get unsettleCard => 'Ещё не внёс';

  @override
  String get remindersTitle => 'Напоминания о платежах';

  @override
  String get remindersEnable => 'Включить';

  @override
  String get remindersOn =>
      'Включены: за 3 дня и в день платежа, в 10:00. Суммы в уведомлениях не показываются.';

  @override
  String get remindersDenied =>
      'Уведомления запрещены. Разрешите их: Настройки iPhone → Денежно → Уведомления.';

  @override
  String canSpendUntilSalary(String date) {
    return 'Можно потратить до зарплаты $date';
  }

  @override
  String get canSpendUntilMonthEnd => 'Можно потратить до конца месяца';

  @override
  String shortBy(String amount) {
    return 'Не хватает $amount';
  }

  @override
  String perDay(String amount, int days) {
    return '≈ $amount в день · дней: $days';
  }

  @override
  String staleNote(String date) {
    return 'По данным на $date. Обновите остатки, чтобы цифра была актуальной.';
  }

  @override
  String get veryStaleNote =>
      'Остатки давно не обновлялись — цифра может сильно отличаться от реальной.';

  @override
  String get howCalculated => 'Как считаем';

  @override
  String get rowMoney => 'Деньги на картах и наличные';

  @override
  String rowPayments(int count) {
    return 'Платежи до этой даты: $count';
  }

  @override
  String get rowCards => 'Кредитки: внести до этой даты';

  @override
  String get rowGoals => 'Отложить на цели';

  @override
  String get rowReserve => 'Резерв (не трогаем)';

  @override
  String get rowResult => 'Можно потратить';

  @override
  String get warnNoAccounts => 'Добавьте счета — без них расчёт невозможен.';

  @override
  String get warnNoSalary =>
      'Зарплата не указана — считаем до конца месяца. Добавьте её во вкладке «Платежи».';

  @override
  String warnCardNoFigures(String name) {
    return 'По «$name» нет цифр банка — платёж не учтён.';
  }

  @override
  String warnMinimumOnly(String name) {
    return 'По «$name» учтён только минимальный платёж — проценты продолжат начисляться.';
  }

  @override
  String get homeEmptyTitle => 'Начните с ваших счетов';

  @override
  String get homeEmptyHint =>
      'Добавьте карты, наличные и кредитки, затем зарплату и регулярные платежи — и здесь появится сумма, которую можно безопасно потратить до следующего дохода.';

  @override
  String get nextPayments => 'Ближайшие платежи';

  @override
  String get reserveTitle => 'Резерв';

  @override
  String get reserveHint =>
      'Сумма, которую приложение никогда не предлагает тратить.';

  @override
  String get reserveEdit => 'Изменить резерв';

  @override
  String get expectedIncomeNote =>
      'Ожидаемые доходы не учитываются, пока не поступят.';

  @override
  String warnPossibleDuplicate(String name) {
    return 'Платёж «$name» не привязан к кредитке или кредиту — проверьте, не учтён ли он дважды вместе с цифрами банка.';
  }

  @override
  String skippedDuplicatesNote(String names) {
    return 'Не учтено повторно: $names — эти деньги уже учтены в цифрах банка или долг погашен.';
  }

  @override
  String get includedInForecast => 'Учитывать в «можно потратить»';

  @override
  String get includedHint =>
      'Выключите для накоплений и счетов, деньги с которых не идут на текущие траты.';

  @override
  String get notIncluded => 'не в расчёте';

  @override
  String get linkedTo => 'Погашает кредитку или кредит (необязательно)';

  @override
  String get linkedHint =>
      'Если у кредитки есть цифры банка, этот платёж не будет учтён второй раз.';

  @override
  String get notLinked => 'Не связан';

  @override
  String get backupTitle => 'Резервная копия';

  @override
  String get backupHint =>
      'Зашифрованный файл со всеми данными. Сохраните его в «Файлы» или отправьте себе. Восстановить можно на новом телефоне или после переустановки.';

  @override
  String get backupCreate => 'Создать копию';

  @override
  String get backupRestore => 'Восстановить из копии';

  @override
  String get backupPassword => 'Пароль для копии (не меньше 8 символов)';

  @override
  String get backupPasswordRepeat => 'Повторите пароль';

  @override
  String get backupPasswordWarning =>
      'Без этого пароля копию восстановить невозможно — ни нам, ни кому-либо ещё. Запишите его.';

  @override
  String get backupPasswordsDiffer => 'Пароли не совпадают';

  @override
  String get backupPasswordShort => 'Пароль короче 8 символов';

  @override
  String get backupCreated => 'Копия создана.';

  @override
  String get backupFailed => 'Не удалось создать копию. Данные не изменены.';

  @override
  String get restoreOnlyEmpty =>
      'Восстановление доступно только в пустое приложение: на новом телефоне или после переустановки. Текущие данные не будут перезаписаны.';

  @override
  String get restoreEnterPassword => 'Пароль от копии';

  @override
  String get restoreDone => 'Данные восстановлены.';

  @override
  String get restoreWrongPassword =>
      'Неверный пароль или файл повреждён. Данные в приложении не изменены.';

  @override
  String get restoreNotBackup => 'Это не резервная копия «Денежно».';

  @override
  String get restoreUnsupported =>
      'Копия создана несовместимой версией приложения. Обновите приложение.';

  @override
  String get restoreIncomplete =>
      'Копия неполная или повреждена. Данные в приложении не изменены.';

  @override
  String get restoreFailed =>
      'Не удалось восстановить. Данные в приложении не изменены.';

  @override
  String get working => 'Подождите…';

  @override
  String warnOverdueFigures(String name, String date) {
    return 'Срок по «$name» ($date) прошёл, а оплата не отмечена. Платёж учтён; внесите новые цифры банка или отметьте «Внёс».';
  }

  @override
  String get themeAuto => 'Авто';

  @override
  String get themeLightShort => 'Светлая';

  @override
  String get themeDarkShort => 'Тёмная';

  @override
  String get settingsFinance => 'Финансы';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get versionLabel => 'Версия';

  @override
  String get developerTitle => 'Для разработчика';

  @override
  String get developerHint =>
      'Техническое состояние хранилища. Пригодится, если что-то пойдёт не так: скопируйте сводку и отправьте разработчику.';

  @override
  String get reserveExplain =>
      'Резерв — неприкосновенная сумма. Приложение вычитает её из «можно потратить», чтобы у вас всегда оставался запас на непредвиденное.';

  @override
  String get backupRowHint => 'Зашифрованный файл со всеми данными';

  @override
  String heroUntil(String date) {
    return 'Можно потратить до $date';
  }

  @override
  String get heroUntilMonthEnd => 'Можно потратить до конца месяца';

  @override
  String heroShortUntil(String date) {
    return 'До $date не хватает';
  }

  @override
  String get heroShortMonthEnd => 'До конца месяца не хватает';

  @override
  String get statusComplete => 'Данные заполнены';

  @override
  String get statusPreliminary => 'Предварительный расчёт';

  @override
  String perDayShort(String amount, int days) {
    return '≈ $amount в день · $days дн.';
  }

  @override
  String get freshToday => 'Остатки обновлены сегодня';

  @override
  String get freshYesterday => 'Остатки обновлены вчера';

  @override
  String freshDays(int days) {
    return 'Остатки обновлены $days дн. назад';
  }

  @override
  String get freshNever => 'Остатки ещё не вносились';

  @override
  String get updateShort => 'Обновить';

  @override
  String get ownMoney => 'Свои деньги';

  @override
  String get debts => 'Долги';

  @override
  String get attentionTitle => 'Требует внимания';

  @override
  String get preliminaryExplain =>
      'Не хватает данных — реальная сумма может быть меньше. Заполните пункты ниже.';

  @override
  String get fixNoAccounts => 'Добавьте счета и карты';

  @override
  String get fixNoSalary => 'Укажите зарплату — дату и сумму';

  @override
  String fixCardNoFigures(String name) {
    return 'Внесите цифры банка по «$name»';
  }

  @override
  String fixOverdue(String name, String date) {
    return 'Срок по «$name» ($date) прошёл — обновите цифры или отметьте оплату';
  }

  @override
  String fixStale(String date) {
    return 'Обновите остатки — данные от $date';
  }

  @override
  String noteMinimumOnly(String name) {
    return 'По «$name» известен только минимальный платёж';
  }

  @override
  String notePossibleDuplicate(String name) {
    return 'Проверьте «$name»: возможно, учтено дважды';
  }

  @override
  String get seeAll => 'Все';

  @override
  String get noUpcoming => 'В ближайшие 30 дней платежей нет';

  @override
  String get savings => 'Накопления';

  @override
  String get addShort => 'Добавить';

  @override
  String get accountEdit => 'Изменить';

  @override
  String get accountSaved => 'Сохранено';

  @override
  String get updateThisBalance => 'Обновить остаток';

  @override
  String get addPaymentOrIncome => 'Что добавить?';

  @override
  String get debtLabel => 'долг';

  @override
  String updatedAgo(String when) {
    return 'обновлено $when';
  }

  @override
  String get creditLimitTitle => 'Кредитный лимит';

  @override
  String get creditAvailable => 'Доступно по лимиту';

  @override
  String heroPeriodDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Расчёт на $days дней',
      few: 'Расчёт на $days дня',
      one: 'Расчёт на $days день',
    );
    return '$_temp0';
  }

  @override
  String heroPeriodUntil(String date) {
    return 'Расчёт до $date';
  }

  @override
  String heroPeriodShortDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'На $days дней не хватает',
      few: 'На $days дня не хватает',
      one: 'На $days день не хватает',
    );
    return '$_temp0';
  }

  @override
  String heroPeriodShortUntil(String date) {
    return 'До $date не хватает';
  }

  @override
  String get periodChange => 'Изменить';

  @override
  String get periodTitle => 'Период расчёта';

  @override
  String get periodHint =>
      'Дата следующей зарплаты неизвестна — выберите, на какой срок считать.';

  @override
  String periodDaysOption(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get periodUntilOption => 'До даты…';

  @override
  String obligationsUntil(String date) {
    return 'Обязательно до $date';
  }

  @override
  String fixSalaryOverdue(String name, String date) {
    return '«$name» $date не отмечена как полученная. Пока не отмечена, не прибавляем её и считаем на выбранный период.';
  }

  @override
  String get salaryReceived => 'Отметить полученной';

  @override
  String get salaryEdit => 'График';

  @override
  String fixCardUnknown(String name, String debt) {
    return '«$name»: долг $debt, обязательный платёж неизвестен. Внесите цифры банка.';
  }

  @override
  String get scenariosTitle => 'Сценарии';

  @override
  String get scenarioAllDebts => 'Если погасить все долги сейчас';

  @override
  String get scenarioAllDebtsShort =>
      'Если погасить все долги сейчас — не хватит';

  @override
  String scenarioAllDebtsNote(String debt) {
    return 'Для понимания общей позиции, а не сумма на траты. Учтены только известные долги: $debt.';
  }

  @override
  String get scenarioMinimum => 'Если по кредиткам платить только минимум';

  @override
  String get scenarioMinimumNote =>
      'Сейчас останется больше, но банк начислит проценты на непогашенный долг.';

  @override
  String get rowCardsTitle => 'Кредитки';

  @override
  String cardDebtLine(String amount) {
    return 'долг $amount';
  }

  @override
  String cardGraceShort(String amount, String date) {
    return 'без процентов: $amount до $date';
  }

  @override
  String cardMinShort(String amount, String date) {
    return 'минимум: $amount до $date';
  }

  @override
  String get cardBasisGrace => 'вычтено: сумма без процентов';

  @override
  String get cardBasisMinimum => 'вычтен минимум — пойдут проценты';

  @override
  String get cardBasisNoFigures => 'платёж неизвестен — не вычтено';

  @override
  String get cardBasisPlanned => 'учтён плановый платёж';

  @override
  String get cardBasisAfter => 'срок после конца расчёта — не вычтено';

  @override
  String get cardBasisSettled => 'отмечено «внёс»';

  @override
  String get cardBasisNoDebt => 'долга нет';

  @override
  String get cardDebtTitle => 'Долг';

  @override
  String get bankFiguresTitle => 'Цифры банка';

  @override
  String get bankFiguresMissing => 'Не указаны — внесите из приложения банка';

  @override
  String get cardGraceRow => 'Без процентов';

  @override
  String get cardMinRow => 'Минимальный платёж';

  @override
  String dueOnValue(String amount, String date) {
    return '$amount до $date';
  }

  @override
  String get salaryMarkedTitle => 'Отмечено как полученное';

  @override
  String get salaryMarkedBody =>
      'Отметка не меняет остатки счетов. Если деньги пришли на карту, обновите её остаток — тогда они появятся в расчёте.';

  @override
  String get salaryMarkedUpdate => 'Обновить остатки';

  @override
  String get salaryMarkedDone => 'Готово';

  @override
  String get salaryScheduleTitle => 'Изменить график?';

  @override
  String get salaryScheduleBody =>
      'Изменение даты здесь сдвинет её во всех следующих месяцах. Перенести одну задержанную выплату можно будет в следующем обновлении, а пока расчёт идёт на выбранный период.';

  @override
  String get salaryScheduleOpen => 'Открыть график';

  @override
  String get marksDontChangeBalances =>
      '«Оплачено» записывает списание со счёта и сразу меняет остаток. Ошибочную оплату можно отменить, нажав на отметку ещё раз.';

  @override
  String get salarySetup => 'Настроить зарплату и аванс';

  @override
  String get salarySetupHint =>
      'Даты и суммы выплат — чтобы считать «до зарплаты»';

  @override
  String get addIncomeSource => 'Добавить ещё работодателя';

  @override
  String get otherIncomesTitle => 'Другие доходы';

  @override
  String get scheduleTitleNew => 'Зарплата и аванс';

  @override
  String get scheduleTitleEdit => 'График выплат';

  @override
  String get sourceName => 'Название';

  @override
  String get sourceNameDefault => 'Работа';

  @override
  String get paymentsPerMonth => 'Выплат в месяц';

  @override
  String get onePayment => 'Одна';

  @override
  String get twoPayments => 'Две';

  @override
  String get partLabel => 'Название выплаты';

  @override
  String get partDay => 'Число месяца';

  @override
  String get partAmount => 'Сумма';

  @override
  String get advanceDefault => 'Аванс';

  @override
  String get salaryDefault => 'Зарплата';

  @override
  String get dayHint => '31 — последний день месяца';

  @override
  String get invalidDay => 'Укажите число от 1 до 31';

  @override
  String get invalidLabel => 'Укажите название';

  @override
  String get incomeAccount => 'Куда приходит';

  @override
  String get incomeAccountNone => 'Не выбрано';

  @override
  String get holidayRuleTitle => 'Если дата выпала на выходной';

  @override
  String get holidayPrevious => 'В предыдущий рабочий день';

  @override
  String get holidayNext => 'В следующий рабочий день';

  @override
  String get holidayNone => 'Не переносить';

  @override
  String get holidayHint =>
      'По Трудовому кодексу (ст. 136) зарплату выплачивают накануне выходного или праздника.';

  @override
  String get scheduleEditNote =>
      'Изменения действуют с сегодняшнего дня. Прошлые выплаты и полученные деньги не меняются.';

  @override
  String get archiveSource => 'Удалить этот доход';

  @override
  String get archiveSourceConfirm =>
      'Новые выплаты перестанут ожидаться. Полученные деньги и история останутся.';

  @override
  String scheduleLine(int day, String amount) {
    return '$day-го · $amount';
  }

  @override
  String get paymentPlan => 'По графику';

  @override
  String get paymentExpected => 'Ожидается';

  @override
  String get paymentReceivedTotal => 'Получено';

  @override
  String get paymentRemaining => 'Осталось получить';

  @override
  String paymentHolidayMoved(String date) {
    return 'перенос с $date из-за выходного';
  }

  @override
  String get dateUnknownValue => 'Дата неизвестна';

  @override
  String get receiptsTitle => 'Поступления';

  @override
  String get receiptCancelled => 'отменено';

  @override
  String get cancelReceipt => 'Отменить';

  @override
  String get cancelReceiptConfirm =>
      'Отменить это поступление? Остаток счёта изменится обратно (если остаток уже подтверждён — сумма вернётся в неясную разницу). Запись останется в истории.';

  @override
  String get actionReceived => 'Получено';

  @override
  String get actionMove => 'Перенести';

  @override
  String get actionUnknown => 'Не знаю когда';

  @override
  String get actionCancelPayment => 'Не будет';

  @override
  String get actionReopen => 'Вернуть';

  @override
  String get actionChangeAmount => 'Изменить сумму';

  @override
  String get actionDetails => 'Подробнее';

  @override
  String get cancelPaymentConfirm =>
      'Отметить, что этой выплаты не будет? Расчёт перестанет её ждать.';

  @override
  String get stateReceived => 'Получена';

  @override
  String get stateCancelled => 'Не будет';

  @override
  String get stateLegacy => 'Отмечена до обновления';

  @override
  String get stateWaiting => 'Ожидается';

  @override
  String get stateOverdue => 'Задерживается';

  @override
  String get statePartial => 'Получена частично';

  @override
  String get receiveTitle => 'Получено';

  @override
  String get receiveAmount => 'Сколько пришло';

  @override
  String get receiveAccount => 'На какой счёт';

  @override
  String get receiveDate => 'Когда пришло';

  @override
  String get receiveCheck => 'Проверьте перед записью';

  @override
  String receiveBalanceChange(String account, String before, String after) {
    return 'Остаток «$account»: было $before, станет $after';
  }

  @override
  String receiveLess(String expected) {
    return 'Ожидалось $expected';
  }

  @override
  String get restLater => 'Остальное придёт позже';

  @override
  String get wholePayment => 'Это вся выплата';

  @override
  String get restDate => 'Когда ждать остальное';

  @override
  String get restUnknown => 'Не знаю';

  @override
  String get receiveConfirm => 'Подтвердить';

  @override
  String get receiveNoAccounts =>
      'Сначала добавьте счёт, на который приходит зарплата';

  @override
  String get receiveFuture => 'Дата не может быть в будущем';

  @override
  String incomeOverdue(String label, String date) {
    return 'Выплата «$label» $date ещё не получена. Пока её нет, не прибавляем и считаем на выбранный период.';
  }

  @override
  String incomeUnknown(String label) {
    return 'Выплата «$label» задерживается, дата неизвестна — считаем на выбранный период.';
  }

  @override
  String incomeDelayed(
    String label,
    String date,
    String perDay,
    String before,
  ) {
    return 'Выплата «$label» перенесена на $date: в день ≈ $perDay вместо $before.';
  }

  @override
  String incomeDelayedSimple(String label, String date) {
    return 'Выплата «$label» перенесена на $date.';
  }

  @override
  String incomePartial(String label, String received, String expected) {
    return '«$label»: получено $received из $expected, остальное ждём.';
  }

  @override
  String get actionSetDate => 'Указать дату';

  @override
  String incomeDue(String date) {
    return '$date';
  }

  @override
  String get paymentNotFound =>
      'Выплата не найдена — возможно, график изменился.';

  @override
  String get storageUpgrade => 'Нужно обновить данные — откройте «Главную».';

  @override
  String get upgradeTitle => 'Обновление данных';

  @override
  String get upgradeText =>
      'В новой версии зарплата и аванс, операции и категории хранятся по-новому. Перед обновлением сохраните резервную копию: приложение проверит её сразу после создания. Ваши данные пока не изменены.';

  @override
  String get upgradeBackup => 'Создать и проверить копию';

  @override
  String upgradeBackupDone(int accounts, int entries) {
    return 'Копия создана и проверена: счетов $accounts, записей журнала $entries. Сохраните файл в надёжное место.';
  }

  @override
  String get upgradeBackupFailed =>
      'Не удалось создать копию. Данные не изменены — попробуйте ещё раз.';

  @override
  String get upgradeContinue => 'Обновить данные';

  @override
  String get upgradeWithoutBackup => 'Обновить без копии?';

  @override
  String get upgradeWithoutBackupText =>
      'На телефоне останется зашифрованная копия базы до обновления, но перенести её на другое устройство нельзя. Рекомендуем сначала создать копию.';

  @override
  String get upgradeAnyway => 'Обновить без копии';

  @override
  String get upgradeAutoCopy =>
      'При обновлении на телефоне автоматически сохраняется зашифрованная копия старой базы.';

  @override
  String get otherIncomeTitle => 'Другой доход';

  @override
  String get otherIncomeHint =>
      'Подработка, кэшбэк, возврат налога и другие поступления. Зарплату и аванс добавляйте через «Зарплата и аванс» — там учитываются задержки, частичные выплаты и выходные.';

  @override
  String get addIncomeWhat => 'Какой доход добавить?';

  @override
  String get sheetSalary => 'Зарплата и аванс';

  @override
  String get sheetSalaryMore => 'Ещё одна зарплата (другой работодатель)';

  @override
  String get sheetOtherIncome => 'Другой доход';

  @override
  String otherIncomeSubtitle(String cadence) {
    return 'Другой доход · $cadence';
  }

  @override
  String get partDayShort => 'Число';

  @override
  String get partDayPlaceholder => '1–31';

  @override
  String get partAmountPlaceholder => '0';

  @override
  String get partLabelPlaceholder => 'Название';

  @override
  String get payTitle => 'Оплачено';

  @override
  String get payAmount => 'Сколько заплатили';

  @override
  String get payAccount => 'С какого счёта';

  @override
  String get payDate => 'Когда заплатили';

  @override
  String payDue(String date) {
    return 'Срок: $date';
  }

  @override
  String get payTransferNote =>
      'Это перевод между вашими счетами: долг уменьшится, расходом это не считается.';

  @override
  String payBalanceChange(String account, String before, String after) {
    return 'Остаток «$account»: было $before, станет $after';
  }

  @override
  String payDebtChange(String account, String before, String after) {
    return 'Долг «$account»: было $before, станет $after';
  }

  @override
  String similarFound(String date, String amount, String what) {
    return 'На этом счёте уже есть похожая операция: $date, $amount$what. Возможно, этот платёж уже записан.';
  }

  @override
  String get similarConfirm => 'Это другая оплата — записать';

  @override
  String get payConfirm => 'Подтвердить оплату';

  @override
  String get paySkip => 'Платежа не будет';

  @override
  String get paySkipConfirm =>
      'Отметить, что этого платежа не будет? Он перестанет учитываться в обязательных. Деньги со счёта не списываются.';

  @override
  String get payAlreadyPaid => 'Этот платёж уже оплачен.';

  @override
  String get payFailed => 'Не удалось записать оплату. Ничего не изменилось.';

  @override
  String paidInfo(String date, String amount, String account) {
    return 'Оплачено $date · $amount$account';
  }

  @override
  String get cancelPaymentAction => 'Отменить оплату';

  @override
  String get cancelPaymentText =>
      'Отменить эту оплату? Операция будет сторнирована, остаток вернётся, платёж снова станет обязательным. Запись останется в истории.';

  @override
  String get skippedInfo => 'Отмечено: платежа не будет';

  @override
  String get unskipAction => 'Вернуть платёж';

  @override
  String get overdueLabel => 'просрочен';

  @override
  String get legacyMarkLabel => 'отмечено до обновления — подтвердите оплату';

  @override
  String fixPaymentOverdue(String name, String date) {
    return '«$name» $date не оплачен — он остаётся в обязательных, пока вы его не оплатите или не отметите, что платежа не будет.';
  }

  @override
  String get pendingTitle => 'Оплаты после прошлого обновления';

  @override
  String get pendingHint =>
      'Ответьте по каждому счёту, который сверяете сейчас. Иначе остаток посчитается неверно.';

  @override
  String pendingLine(String title, String amount, String date) {
    return '$title · $amount · $date';
  }

  @override
  String pendingDebitQuestion(String account) {
    return '«$account»: Банк уже списал деньги?';
  }

  @override
  String pendingCreditQuestion(String account) {
    return '«$account»: Банк уже зачислил перевод?';
  }

  @override
  String get pendingDebited => 'Уже списано';

  @override
  String get pendingNotYet => 'Ещё не списано';

  @override
  String get pendingCredited => 'Уже зачислено';

  @override
  String get pendingNotYetCredited => 'Ещё не зачислено';

  @override
  String get pendingNeedAnswer => 'Ответьте на каждый вопрос выше';

  @override
  String get payNoAccounts => 'Сначала добавьте счёт, с которого платите';

  @override
  String confirmBalanceQuestion(String account, String when) {
    return 'Остаток «$account» подтверждён $when — в день операции или позже. Эта операция уже была в нём?';
  }

  @override
  String confirmDebtQuestion(String account, String when) {
    return 'Долг «$account» подтверждён $when — в день операции или позже. Этот платёж уже был в нём учтён?';
  }

  @override
  String get confirmYes => 'Уже была';

  @override
  String get confirmNo => 'Ещё нет';

  @override
  String figuresQuestion(String due, String date) {
    return 'Сумма к оплате $due, введённая $date, уже учитывает этот платёж?';
  }

  @override
  String get figuresYes => 'Да, уже учтён';

  @override
  String get figuresNo => 'Нет, ещё не учтён';

  @override
  String get payRecheck =>
      'Пока вы отвечали, изменились сверка или цифры банка. Ничего не записано — ответьте на вопросы ещё раз.';

  @override
  String get payFiguresChanged =>
      'Цифры банка по этой кредитке изменились. Ничего не записано — вернитесь и откройте оплату по актуальной сумме.';

  @override
  String get payBackToPayments => 'Вернуться';

  @override
  String get enterBankAmount => 'Введите сумму из банка';
}
