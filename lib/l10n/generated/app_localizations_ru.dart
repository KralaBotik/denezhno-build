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
    return 'По данным на $date. Обновите остатки, чтобы цифра была точной.';
  }

  @override
  String get veryStaleNote =>
      'Остатки давно не обновлялись — цифра может быть неточной.';

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
}
