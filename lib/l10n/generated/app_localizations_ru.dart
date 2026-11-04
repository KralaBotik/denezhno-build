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
  String get incomeTitle => 'Доход';

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
      'Отметка «оплачено» или «получено» не меняет остатки — обновите их на вкладке «Счета».';
}
