import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @appName.
  ///
  /// In ru, this message translates to:
  /// **'Денежно'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home;

  /// No description provided for @accounts.
  ///
  /// In ru, this message translates to:
  /// **'Счета'**
  String get accounts;

  /// No description provided for @transactions.
  ///
  /// In ru, this message translates to:
  /// **'Операции'**
  String get transactions;

  /// No description provided for @payments.
  ///
  /// In ru, this message translates to:
  /// **'Платежи'**
  String get payments;

  /// No description provided for @forecast.
  ///
  /// In ru, this message translates to:
  /// **'Прогноз'**
  String get forecast;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Ваши финансы — под рукой'**
  String get welcome;

  /// No description provided for @homeEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появится обзор ваших денег, расходов и ближайших платежей.'**
  String get homeEmpty;

  /// No description provided for @accountsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут ваши счета и их остатки.'**
  String get accountsEmpty;

  /// No description provided for @transactionsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будет история доходов, расходов и переводов.'**
  String get transactionsEmpty;

  /// No description provided for @paymentsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут обязательные платежи и напоминания.'**
  String get paymentsEmpty;

  /// No description provided for @forecastEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появится прогноз доступных средств.'**
  String get forecastEmpty;

  /// No description provided for @notAvailableYet.
  ///
  /// In ru, this message translates to:
  /// **'Учёт финансов пока недоступен.'**
  String get notAvailableYet;

  /// No description provided for @appearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлое'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмное'**
  String get themeDark;

  /// No description provided for @storage.
  ///
  /// In ru, this message translates to:
  /// **'Хранение'**
  String get storage;

  /// No description provided for @storageOpening.
  ///
  /// In ru, this message translates to:
  /// **'Открываем защищённое хранилище…'**
  String get storageOpening;

  /// No description provided for @storageReady.
  ///
  /// In ru, this message translates to:
  /// **'Настройки сохраняются на этом устройстве.'**
  String get storageReady;

  /// No description provided for @storagePaused.
  ///
  /// In ru, this message translates to:
  /// **'Хранилище закрыто до возвращения в приложение.'**
  String get storagePaused;

  /// No description provided for @storageError.
  ///
  /// In ru, this message translates to:
  /// **'Защищённое хранилище недоступно. Существующие данные сохранены. Разблокируйте устройство и повторите попытку.'**
  String get storageError;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @syncUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация пока недоступна.'**
  String get syncUnavailable;

  /// No description provided for @selectedTheme.
  ///
  /// In ru, this message translates to:
  /// **'Выбранное оформление'**
  String get selectedTheme;

  /// No description provided for @diagnostics.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика'**
  String get diagnostics;

  /// No description provided for @diagnosticsHint.
  ///
  /// In ru, this message translates to:
  /// **'Техническая сводка без ключей, путей и ваших данных. Её можно скопировать и отправить разработчику.'**
  String get diagnosticsHint;

  /// No description provided for @copyDiagnostics.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать диагностику'**
  String get copyDiagnostics;

  /// No description provided for @diagnosticsCopied.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика скопирована.'**
  String get diagnosticsCopied;

  /// No description provided for @diagnosticsCopyFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось скопировать диагностику.'**
  String get diagnosticsCopyFailed;

  /// No description provided for @addAccount.
  ///
  /// In ru, this message translates to:
  /// **'Добавить счёт'**
  String get addAccount;

  /// No description provided for @updateBalances.
  ///
  /// In ru, this message translates to:
  /// **'Обновить остатки'**
  String get updateBalances;

  /// No description provided for @accountsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет счетов'**
  String get accountsEmptyTitle;

  /// No description provided for @accountsEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте карты, наличные, накопления, кредитки и кредиты — так приложение увидит все ваши деньги и долги.'**
  String get accountsEmptyHint;

  /// No description provided for @accountsStorageClosed.
  ///
  /// In ru, this message translates to:
  /// **'Счета появятся, когда откроется защищённое хранилище.'**
  String get accountsStorageClosed;

  /// No description provided for @accountsLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить счета. Данные не изменены.'**
  String get accountsLoadFailed;

  /// No description provided for @groupMoney.
  ///
  /// In ru, this message translates to:
  /// **'Деньги'**
  String get groupMoney;

  /// No description provided for @groupSavings.
  ///
  /// In ru, this message translates to:
  /// **'Накопления'**
  String get groupSavings;

  /// No description provided for @groupDebts.
  ///
  /// In ru, this message translates to:
  /// **'Долги'**
  String get groupDebts;

  /// No description provided for @totalOwnMoney.
  ///
  /// In ru, this message translates to:
  /// **'Свои деньги'**
  String get totalOwnMoney;

  /// No description provided for @kindDebit.
  ///
  /// In ru, this message translates to:
  /// **'Дебетовая карта'**
  String get kindDebit;

  /// No description provided for @kindCash.
  ///
  /// In ru, this message translates to:
  /// **'Наличные'**
  String get kindCash;

  /// No description provided for @kindSavings.
  ///
  /// In ru, this message translates to:
  /// **'Накопительный счёт'**
  String get kindSavings;

  /// No description provided for @kindDeposit.
  ///
  /// In ru, this message translates to:
  /// **'Вклад'**
  String get kindDeposit;

  /// No description provided for @kindCreditCard.
  ///
  /// In ru, this message translates to:
  /// **'Кредитная карта'**
  String get kindCreditCard;

  /// No description provided for @kindLoan.
  ///
  /// In ru, this message translates to:
  /// **'Кредит'**
  String get kindLoan;

  /// No description provided for @updatedToday.
  ///
  /// In ru, this message translates to:
  /// **'обновлено сегодня'**
  String get updatedToday;

  /// No description provided for @updatedYesterday.
  ///
  /// In ru, this message translates to:
  /// **'обновлено вчера'**
  String get updatedYesterday;

  /// No description provided for @updatedDaysAgo.
  ///
  /// In ru, this message translates to:
  /// **'обновлено {days} дн. назад'**
  String updatedDaysAgo(int days);

  /// No description provided for @creditLimitValue.
  ///
  /// In ru, this message translates to:
  /// **'лимит {amount}'**
  String creditLimitValue(String amount);

  /// No description provided for @accountKind.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get accountKind;

  /// No description provided for @fieldName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get fieldName;

  /// No description provided for @fieldAmountAsset.
  ///
  /// In ru, this message translates to:
  /// **'Сколько сейчас на счёте'**
  String get fieldAmountAsset;

  /// No description provided for @fieldAmountCard.
  ///
  /// In ru, this message translates to:
  /// **'Сколько сейчас должны банку'**
  String get fieldAmountCard;

  /// No description provided for @fieldAmountLoan.
  ///
  /// In ru, this message translates to:
  /// **'Сколько осталось выплатить'**
  String get fieldAmountLoan;

  /// No description provided for @fieldCreditLimit.
  ///
  /// In ru, this message translates to:
  /// **'Кредитный лимит (необязательно)'**
  String get fieldCreditLimit;

  /// No description provided for @protectedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Не трогать'**
  String get protectedLabel;

  /// No description provided for @protectedHint.
  ///
  /// In ru, this message translates to:
  /// **'Не учитывать в «можно потратить» — для накоплений.'**
  String get protectedHint;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @invalidAmount.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму, например 12 345,67'**
  String get invalidAmount;

  /// No description provided for @nameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get nameRequired;

  /// No description provided for @saveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Данные не изменены.'**
  String get saveFailed;

  /// No description provided for @unchanged.
  ///
  /// In ru, this message translates to:
  /// **'Не изменилось'**
  String get unchanged;

  /// No description provided for @currentAmount.
  ///
  /// In ru, this message translates to:
  /// **'сейчас {amount}'**
  String currentAmount(String amount);

  /// No description provided for @updateHint.
  ///
  /// In ru, this message translates to:
  /// **'Откройте приложения банков и впишите текущие суммы. Если сумма не изменилась — нажмите «Не изменилось». Пустые поля не меняются.'**
  String get updateHint;

  /// No description provided for @updateResultExpenses.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены. Неучтённые расходы: {amount}'**
  String updateResultExpenses(String amount);

  /// No description provided for @updateResultIncome.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены. Неучтённые поступления: {amount}'**
  String updateResultIncome(String amount);

  /// No description provided for @updateResultNone.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены.'**
  String get updateResultNone;

  /// No description provided for @upcomingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие 30 дней'**
  String get upcomingTitle;

  /// No description provided for @upcomingEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся ближайшие платежи и поступления. Добавьте регулярный платёж, зарплату или цифры кредитки.'**
  String get upcomingEmpty;

  /// No description provided for @creditCardsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кредитки: цифры банка'**
  String get creditCardsTitle;

  /// No description provided for @cardNoFigures.
  ///
  /// In ru, this message translates to:
  /// **'Внесите цифры из приложения банка'**
  String get cardNoFigures;

  /// No description provided for @cardGraceLine.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы не платить проценты: {amount} до {date}'**
  String cardGraceLine(String amount, String date);

  /// No description provided for @cardMinLine.
  ///
  /// In ru, this message translates to:
  /// **'Минимальный платёж: {amount} до {date}'**
  String cardMinLine(String amount, String date);

  /// No description provided for @cardMinOnly.
  ///
  /// In ru, this message translates to:
  /// **'минимальный платёж — сумма для льготного периода не указана'**
  String get cardMinOnly;

  /// No description provided for @cardSettled.
  ///
  /// In ru, this message translates to:
  /// **'внесено'**
  String get cardSettled;

  /// No description provided for @recurringTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регулярные платежи'**
  String get recurringTitle;

  /// No description provided for @incomesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Доходы'**
  String get incomesTitle;

  /// No description provided for @addPayment.
  ///
  /// In ru, this message translates to:
  /// **'Добавить платёж'**
  String get addPayment;

  /// No description provided for @addIncome.
  ///
  /// In ru, this message translates to:
  /// **'Добавить доход'**
  String get addIncome;

  /// No description provided for @paymentTitle.
  ///
  /// In ru, this message translates to:
  /// **'Платёж'**
  String get paymentTitle;

  /// No description provided for @incomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Доходы'**
  String get incomeTitle;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @markPaid.
  ///
  /// In ru, this message translates to:
  /// **'Оплачено'**
  String get markPaid;

  /// No description provided for @markReceived.
  ///
  /// In ru, this message translates to:
  /// **'Получено'**
  String get markReceived;

  /// No description provided for @markDone.
  ///
  /// In ru, this message translates to:
  /// **'Сделано'**
  String get markDone;

  /// No description provided for @undoMark.
  ///
  /// In ru, this message translates to:
  /// **'Отменить отметку'**
  String get undoMark;

  /// No description provided for @dueToday.
  ///
  /// In ru, this message translates to:
  /// **'сегодня'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In ru, this message translates to:
  /// **'завтра'**
  String get dueTomorrow;

  /// No description provided for @flowKindSalary.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата'**
  String get flowKindSalary;

  /// No description provided for @flowKindOtherIncome.
  ///
  /// In ru, this message translates to:
  /// **'Другой доход'**
  String get flowKindOtherIncome;

  /// No description provided for @flowKindSubscription.
  ///
  /// In ru, this message translates to:
  /// **'Подписка'**
  String get flowKindSubscription;

  /// No description provided for @flowKindUtilities.
  ///
  /// In ru, this message translates to:
  /// **'Коммунальные'**
  String get flowKindUtilities;

  /// No description provided for @flowKindLoanPayment.
  ///
  /// In ru, this message translates to:
  /// **'Платёж по кредиту'**
  String get flowKindLoanPayment;

  /// No description provided for @flowKindRent.
  ///
  /// In ru, this message translates to:
  /// **'Аренда'**
  String get flowKindRent;

  /// No description provided for @flowKindCommunication.
  ///
  /// In ru, this message translates to:
  /// **'Связь и интернет'**
  String get flowKindCommunication;

  /// No description provided for @flowKindOtherPayment.
  ///
  /// In ru, this message translates to:
  /// **'Другое'**
  String get flowKindOtherPayment;

  /// No description provided for @cadenceMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Каждый месяц'**
  String get cadenceMonthly;

  /// No description provided for @cadenceWeekly.
  ///
  /// In ru, this message translates to:
  /// **'Каждую неделю'**
  String get cadenceWeekly;

  /// No description provided for @cadenceYearly.
  ///
  /// In ru, this message translates to:
  /// **'Каждый год'**
  String get cadenceYearly;

  /// No description provided for @cadenceOnce.
  ///
  /// In ru, this message translates to:
  /// **'Один раз'**
  String get cadenceOnce;

  /// No description provided for @monthlyOn.
  ///
  /// In ru, this message translates to:
  /// **'{day}-го числа каждый месяц'**
  String monthlyOn(int day);

  /// No description provided for @weeklyOn.
  ///
  /// In ru, this message translates to:
  /// **'каждую неделю: {weekday}'**
  String weeklyOn(String weekday);

  /// No description provided for @yearlyOn.
  ///
  /// In ru, this message translates to:
  /// **'{date} каждый год'**
  String yearlyOn(String date);

  /// No description provided for @onceOn.
  ///
  /// In ru, this message translates to:
  /// **'{date}, один раз'**
  String onceOn(String date);

  /// No description provided for @fieldKind.
  ///
  /// In ru, this message translates to:
  /// **'Вид'**
  String get fieldKind;

  /// No description provided for @fieldAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get fieldAmount;

  /// No description provided for @fieldSchedule.
  ///
  /// In ru, this message translates to:
  /// **'Когда'**
  String get fieldSchedule;

  /// No description provided for @chooseDate.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать'**
  String get chooseDate;

  /// No description provided for @graceAmountField.
  ///
  /// In ru, this message translates to:
  /// **'Внести, чтобы не платить проценты'**
  String get graceAmountField;

  /// No description provided for @minPaymentField.
  ///
  /// In ru, this message translates to:
  /// **'Минимальный платёж'**
  String get minPaymentField;

  /// No description provided for @dueDateField.
  ///
  /// In ru, this message translates to:
  /// **'До какого числа'**
  String get dueDateField;

  /// No description provided for @cardFiguresHint.
  ///
  /// In ru, this message translates to:
  /// **'Перепишите цифры с экрана кредитки в приложении банка. Цифры банка главные — мы их не пересчитываем. Можно указать только одну из сумм.'**
  String get cardFiguresHint;

  /// No description provided for @figuresNeedOne.
  ///
  /// In ru, this message translates to:
  /// **'Укажите хотя бы одну сумму'**
  String get figuresNeedOne;

  /// No description provided for @settleCard.
  ///
  /// In ru, this message translates to:
  /// **'Внёс'**
  String get settleCard;

  /// No description provided for @unsettleCard.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не внёс'**
  String get unsettleCard;

  /// No description provided for @remindersTitle.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о платежах'**
  String get remindersTitle;

  /// No description provided for @remindersEnable.
  ///
  /// In ru, this message translates to:
  /// **'Включить'**
  String get remindersEnable;

  /// No description provided for @remindersOn.
  ///
  /// In ru, this message translates to:
  /// **'Включены: за 3 дня и в день платежа, в 10:00. Суммы в уведомлениях не показываются.'**
  String get remindersOn;

  /// No description provided for @remindersDenied.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления запрещены. Разрешите их: Настройки iPhone → Денежно → Уведомления.'**
  String get remindersDenied;

  /// No description provided for @canSpendUntilSalary.
  ///
  /// In ru, this message translates to:
  /// **'Можно потратить до зарплаты {date}'**
  String canSpendUntilSalary(String date);

  /// No description provided for @canSpendUntilMonthEnd.
  ///
  /// In ru, this message translates to:
  /// **'Можно потратить до конца месяца'**
  String get canSpendUntilMonthEnd;

  /// No description provided for @shortBy.
  ///
  /// In ru, this message translates to:
  /// **'Не хватает {amount}'**
  String shortBy(String amount);

  /// No description provided for @perDay.
  ///
  /// In ru, this message translates to:
  /// **'≈ {amount} в день · дней: {days}'**
  String perDay(String amount, int days);

  /// No description provided for @staleNote.
  ///
  /// In ru, this message translates to:
  /// **'По данным на {date}. Обновите остатки, чтобы цифра была актуальной.'**
  String staleNote(String date);

  /// No description provided for @veryStaleNote.
  ///
  /// In ru, this message translates to:
  /// **'Остатки давно не обновлялись — цифра может сильно отличаться от реальной.'**
  String get veryStaleNote;

  /// No description provided for @howCalculated.
  ///
  /// In ru, this message translates to:
  /// **'Как считаем'**
  String get howCalculated;

  /// No description provided for @rowMoney.
  ///
  /// In ru, this message translates to:
  /// **'Деньги на картах и наличные'**
  String get rowMoney;

  /// No description provided for @rowPayments.
  ///
  /// In ru, this message translates to:
  /// **'Платежи до этой даты: {count}'**
  String rowPayments(int count);

  /// No description provided for @rowCards.
  ///
  /// In ru, this message translates to:
  /// **'Кредитки: внести до этой даты'**
  String get rowCards;

  /// No description provided for @rowGoals.
  ///
  /// In ru, this message translates to:
  /// **'Отложить на цели'**
  String get rowGoals;

  /// No description provided for @rowReserve.
  ///
  /// In ru, this message translates to:
  /// **'Резерв (не трогаем)'**
  String get rowReserve;

  /// No description provided for @rowResult.
  ///
  /// In ru, this message translates to:
  /// **'Можно потратить'**
  String get rowResult;

  /// No description provided for @warnNoAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте счета — без них расчёт невозможен.'**
  String get warnNoAccounts;

  /// No description provided for @warnNoSalary.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата не указана — считаем до конца месяца. Добавьте её во вкладке «Платежи».'**
  String get warnNoSalary;

  /// No description provided for @warnCardNoFigures.
  ///
  /// In ru, this message translates to:
  /// **'По «{name}» нет цифр банка — платёж не учтён.'**
  String warnCardNoFigures(String name);

  /// No description provided for @warnMinimumOnly.
  ///
  /// In ru, this message translates to:
  /// **'По «{name}» учтён только минимальный платёж — проценты продолжат начисляться.'**
  String warnMinimumOnly(String name);

  /// No description provided for @homeEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Начните с ваших счетов'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте карты, наличные и кредитки, затем зарплату и регулярные платежи — и здесь появится сумма, которую можно безопасно потратить до следующего дохода.'**
  String get homeEmptyHint;

  /// No description provided for @nextPayments.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие платежи'**
  String get nextPayments;

  /// No description provided for @reserveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Резерв'**
  String get reserveTitle;

  /// No description provided for @reserveHint.
  ///
  /// In ru, this message translates to:
  /// **'Сумма, которую приложение никогда не предлагает тратить.'**
  String get reserveHint;

  /// No description provided for @reserveEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить резерв'**
  String get reserveEdit;

  /// No description provided for @expectedIncomeNote.
  ///
  /// In ru, this message translates to:
  /// **'Ожидаемые доходы не учитываются, пока не поступят.'**
  String get expectedIncomeNote;

  /// No description provided for @warnPossibleDuplicate.
  ///
  /// In ru, this message translates to:
  /// **'Платёж «{name}» не привязан к кредитке или кредиту — проверьте, не учтён ли он дважды вместе с цифрами банка.'**
  String warnPossibleDuplicate(String name);

  /// No description provided for @skippedDuplicatesNote.
  ///
  /// In ru, this message translates to:
  /// **'Не учтено повторно: {names} — эти деньги уже учтены в цифрах банка или долг погашен.'**
  String skippedDuplicatesNote(String names);

  /// No description provided for @includedInForecast.
  ///
  /// In ru, this message translates to:
  /// **'Учитывать в «можно потратить»'**
  String get includedInForecast;

  /// No description provided for @includedHint.
  ///
  /// In ru, this message translates to:
  /// **'Выключите для накоплений и счетов, деньги с которых не идут на текущие траты.'**
  String get includedHint;

  /// No description provided for @notIncluded.
  ///
  /// In ru, this message translates to:
  /// **'не в расчёте'**
  String get notIncluded;

  /// No description provided for @linkedTo.
  ///
  /// In ru, this message translates to:
  /// **'Погашает кредитку или кредит (необязательно)'**
  String get linkedTo;

  /// No description provided for @linkedHint.
  ///
  /// In ru, this message translates to:
  /// **'Если у кредитки есть цифры банка, этот платёж не будет учтён второй раз.'**
  String get linkedHint;

  /// No description provided for @notLinked.
  ///
  /// In ru, this message translates to:
  /// **'Не связан'**
  String get notLinked;

  /// No description provided for @backupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Резервная копия'**
  String get backupTitle;

  /// No description provided for @backupHint.
  ///
  /// In ru, this message translates to:
  /// **'Зашифрованный файл со всеми данными. Сохраните его в «Файлы» или отправьте себе. Восстановить можно на новом телефоне или после переустановки.'**
  String get backupHint;

  /// No description provided for @backupCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать копию'**
  String get backupCreate;

  /// No description provided for @backupRestore.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить из копии'**
  String get backupRestore;

  /// No description provided for @backupPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль для копии (не меньше 8 символов)'**
  String get backupPassword;

  /// No description provided for @backupPasswordRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторите пароль'**
  String get backupPasswordRepeat;

  /// No description provided for @backupPasswordWarning.
  ///
  /// In ru, this message translates to:
  /// **'Без этого пароля копию восстановить невозможно — ни нам, ни кому-либо ещё. Запишите его.'**
  String get backupPasswordWarning;

  /// No description provided for @backupPasswordsDiffer.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get backupPasswordsDiffer;

  /// No description provided for @backupPasswordShort.
  ///
  /// In ru, this message translates to:
  /// **'Пароль короче 8 символов'**
  String get backupPasswordShort;

  /// No description provided for @backupCreated.
  ///
  /// In ru, this message translates to:
  /// **'Копия создана.'**
  String get backupCreated;

  /// No description provided for @backupFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось создать копию. Данные не изменены.'**
  String get backupFailed;

  /// No description provided for @restoreOnlyEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление доступно только в пустое приложение: на новом телефоне или после переустановки. Текущие данные не будут перезаписаны.'**
  String get restoreOnlyEmpty;

  /// No description provided for @restoreEnterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль от копии'**
  String get restoreEnterPassword;

  /// No description provided for @restoreDone.
  ///
  /// In ru, this message translates to:
  /// **'Данные восстановлены.'**
  String get restoreDone;

  /// No description provided for @restoreWrongPassword.
  ///
  /// In ru, this message translates to:
  /// **'Неверный пароль или файл повреждён. Данные в приложении не изменены.'**
  String get restoreWrongPassword;

  /// No description provided for @restoreNotBackup.
  ///
  /// In ru, this message translates to:
  /// **'Это не резервная копия «Денежно».'**
  String get restoreNotBackup;

  /// No description provided for @restoreUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Копия создана несовместимой версией приложения. Обновите приложение.'**
  String get restoreUnsupported;

  /// No description provided for @restoreIncomplete.
  ///
  /// In ru, this message translates to:
  /// **'Копия неполная или повреждена. Данные в приложении не изменены.'**
  String get restoreIncomplete;

  /// No description provided for @restoreFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось восстановить. Данные в приложении не изменены.'**
  String get restoreFailed;

  /// No description provided for @working.
  ///
  /// In ru, this message translates to:
  /// **'Подождите…'**
  String get working;

  /// No description provided for @warnOverdueFigures.
  ///
  /// In ru, this message translates to:
  /// **'Срок по «{name}» ({date}) прошёл, а оплата не отмечена. Платёж учтён; внесите новые цифры банка или отметьте «Внёс».'**
  String warnOverdueFigures(String name, String date);

  /// No description provided for @themeAuto.
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get themeAuto;

  /// No description provided for @themeLightShort.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLightShort;

  /// No description provided for @themeDarkShort.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDarkShort;

  /// No description provided for @settingsFinance.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get settingsFinance;

  /// No description provided for @settingsData.
  ///
  /// In ru, this message translates to:
  /// **'Данные'**
  String get settingsData;

  /// No description provided for @settingsAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsAbout;

  /// No description provided for @versionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get versionLabel;

  /// No description provided for @developerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Для разработчика'**
  String get developerTitle;

  /// No description provided for @developerHint.
  ///
  /// In ru, this message translates to:
  /// **'Техническое состояние хранилища. Пригодится, если что-то пойдёт не так: скопируйте сводку и отправьте разработчику.'**
  String get developerHint;

  /// No description provided for @reserveExplain.
  ///
  /// In ru, this message translates to:
  /// **'Резерв — неприкосновенная сумма. Приложение вычитает её из «можно потратить», чтобы у вас всегда оставался запас на непредвиденное.'**
  String get reserveExplain;

  /// No description provided for @backupRowHint.
  ///
  /// In ru, this message translates to:
  /// **'Зашифрованный файл со всеми данными'**
  String get backupRowHint;

  /// No description provided for @heroUntil.
  ///
  /// In ru, this message translates to:
  /// **'Можно потратить до {date}'**
  String heroUntil(String date);

  /// No description provided for @heroUntilMonthEnd.
  ///
  /// In ru, this message translates to:
  /// **'Можно потратить до конца месяца'**
  String get heroUntilMonthEnd;

  /// No description provided for @heroShortUntil.
  ///
  /// In ru, this message translates to:
  /// **'До {date} не хватает'**
  String heroShortUntil(String date);

  /// No description provided for @heroShortMonthEnd.
  ///
  /// In ru, this message translates to:
  /// **'До конца месяца не хватает'**
  String get heroShortMonthEnd;

  /// No description provided for @statusComplete.
  ///
  /// In ru, this message translates to:
  /// **'Данные заполнены'**
  String get statusComplete;

  /// No description provided for @statusPreliminary.
  ///
  /// In ru, this message translates to:
  /// **'Предварительный расчёт'**
  String get statusPreliminary;

  /// No description provided for @perDayShort.
  ///
  /// In ru, this message translates to:
  /// **'≈ {amount} в день · {days} дн.'**
  String perDayShort(String amount, int days);

  /// No description provided for @freshToday.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены сегодня'**
  String get freshToday;

  /// No description provided for @freshYesterday.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены вчера'**
  String get freshYesterday;

  /// No description provided for @freshDays.
  ///
  /// In ru, this message translates to:
  /// **'Остатки обновлены {days} дн. назад'**
  String freshDays(int days);

  /// No description provided for @freshNever.
  ///
  /// In ru, this message translates to:
  /// **'Остатки ещё не вносились'**
  String get freshNever;

  /// No description provided for @updateShort.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get updateShort;

  /// No description provided for @ownMoney.
  ///
  /// In ru, this message translates to:
  /// **'Свои деньги'**
  String get ownMoney;

  /// No description provided for @debts.
  ///
  /// In ru, this message translates to:
  /// **'Долги'**
  String get debts;

  /// No description provided for @attentionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Требует внимания'**
  String get attentionTitle;

  /// No description provided for @preliminaryExplain.
  ///
  /// In ru, this message translates to:
  /// **'Не хватает данных — реальная сумма может быть меньше. Заполните пункты ниже.'**
  String get preliminaryExplain;

  /// No description provided for @fixNoAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте счета и карты'**
  String get fixNoAccounts;

  /// No description provided for @fixNoSalary.
  ///
  /// In ru, this message translates to:
  /// **'Укажите зарплату — дату и сумму'**
  String get fixNoSalary;

  /// No description provided for @fixCardNoFigures.
  ///
  /// In ru, this message translates to:
  /// **'Внесите цифры банка по «{name}»'**
  String fixCardNoFigures(String name);

  /// No description provided for @fixOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Срок по «{name}» ({date}) прошёл — обновите цифры или отметьте оплату'**
  String fixOverdue(String name, String date);

  /// No description provided for @fixStale.
  ///
  /// In ru, this message translates to:
  /// **'Обновите остатки — данные от {date}'**
  String fixStale(String date);

  /// No description provided for @noteMinimumOnly.
  ///
  /// In ru, this message translates to:
  /// **'По «{name}» известен только минимальный платёж'**
  String noteMinimumOnly(String name);

  /// No description provided for @notePossibleDuplicate.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте «{name}»: возможно, учтено дважды'**
  String notePossibleDuplicate(String name);

  /// No description provided for @seeAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get seeAll;

  /// No description provided for @noUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'В ближайшие 30 дней платежей нет'**
  String get noUpcoming;

  /// No description provided for @savings.
  ///
  /// In ru, this message translates to:
  /// **'Накопления'**
  String get savings;

  /// No description provided for @addShort.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get addShort;

  /// No description provided for @accountEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get accountEdit;

  /// No description provided for @accountSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено'**
  String get accountSaved;

  /// No description provided for @updateThisBalance.
  ///
  /// In ru, this message translates to:
  /// **'Обновить остаток'**
  String get updateThisBalance;

  /// No description provided for @addPaymentOrIncome.
  ///
  /// In ru, this message translates to:
  /// **'Что добавить?'**
  String get addPaymentOrIncome;

  /// No description provided for @debtLabel.
  ///
  /// In ru, this message translates to:
  /// **'долг'**
  String get debtLabel;

  /// No description provided for @updatedAgo.
  ///
  /// In ru, this message translates to:
  /// **'обновлено {when}'**
  String updatedAgo(String when);

  /// No description provided for @creditLimitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кредитный лимит'**
  String get creditLimitTitle;

  /// No description provided for @creditAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступно по лимиту'**
  String get creditAvailable;

  /// No description provided for @heroPeriodDays.
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{Расчёт на {days} день} few{Расчёт на {days} дня} other{Расчёт на {days} дней}}'**
  String heroPeriodDays(int days);

  /// No description provided for @heroPeriodUntil.
  ///
  /// In ru, this message translates to:
  /// **'Расчёт до {date}'**
  String heroPeriodUntil(String date);

  /// No description provided for @heroPeriodShortDays.
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{На {days} день не хватает} few{На {days} дня не хватает} other{На {days} дней не хватает}}'**
  String heroPeriodShortDays(int days);

  /// No description provided for @heroPeriodShortUntil.
  ///
  /// In ru, this message translates to:
  /// **'До {date} не хватает'**
  String heroPeriodShortUntil(String date);

  /// No description provided for @periodChange.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get periodChange;

  /// No description provided for @periodTitle.
  ///
  /// In ru, this message translates to:
  /// **'Период расчёта'**
  String get periodTitle;

  /// No description provided for @periodHint.
  ///
  /// In ru, this message translates to:
  /// **'Дата следующей зарплаты неизвестна — выберите, на какой срок считать.'**
  String get periodHint;

  /// No description provided for @periodDaysOption.
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{{days} день} few{{days} дня} other{{days} дней}}'**
  String periodDaysOption(int days);

  /// No description provided for @periodUntilOption.
  ///
  /// In ru, this message translates to:
  /// **'До даты…'**
  String get periodUntilOption;

  /// No description provided for @obligationsUntil.
  ///
  /// In ru, this message translates to:
  /// **'Обязательно до {date}'**
  String obligationsUntil(String date);

  /// No description provided for @fixSalaryOverdue.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» {date} не отмечена как полученная. Пока не отмечена, не прибавляем её и считаем на выбранный период.'**
  String fixSalaryOverdue(String name, String date);

  /// No description provided for @salaryReceived.
  ///
  /// In ru, this message translates to:
  /// **'Отметить полученной'**
  String get salaryReceived;

  /// No description provided for @salaryEdit.
  ///
  /// In ru, this message translates to:
  /// **'График'**
  String get salaryEdit;

  /// No description provided for @fixCardUnknown.
  ///
  /// In ru, this message translates to:
  /// **'«{name}»: долг {debt}, обязательный платёж неизвестен. Внесите цифры банка.'**
  String fixCardUnknown(String name, String debt);

  /// No description provided for @scenariosTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сценарии'**
  String get scenariosTitle;

  /// No description provided for @scenarioAllDebts.
  ///
  /// In ru, this message translates to:
  /// **'Если погасить все долги сейчас'**
  String get scenarioAllDebts;

  /// No description provided for @scenarioAllDebtsShort.
  ///
  /// In ru, this message translates to:
  /// **'Если погасить все долги сейчас — не хватит'**
  String get scenarioAllDebtsShort;

  /// No description provided for @scenarioAllDebtsNote.
  ///
  /// In ru, this message translates to:
  /// **'Для понимания общей позиции, а не сумма на траты. Учтены только известные долги: {debt}.'**
  String scenarioAllDebtsNote(String debt);

  /// No description provided for @scenarioMinimum.
  ///
  /// In ru, this message translates to:
  /// **'Если по кредиткам платить только минимум'**
  String get scenarioMinimum;

  /// No description provided for @scenarioMinimumNote.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас останется больше, но банк начислит проценты на непогашенный долг.'**
  String get scenarioMinimumNote;

  /// No description provided for @rowCardsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кредитки'**
  String get rowCardsTitle;

  /// No description provided for @cardDebtLine.
  ///
  /// In ru, this message translates to:
  /// **'долг {amount}'**
  String cardDebtLine(String amount);

  /// No description provided for @cardGraceShort.
  ///
  /// In ru, this message translates to:
  /// **'без процентов: {amount} до {date}'**
  String cardGraceShort(String amount, String date);

  /// No description provided for @cardMinShort.
  ///
  /// In ru, this message translates to:
  /// **'минимум: {amount} до {date}'**
  String cardMinShort(String amount, String date);

  /// No description provided for @cardBasisGrace.
  ///
  /// In ru, this message translates to:
  /// **'вычтено: сумма без процентов'**
  String get cardBasisGrace;

  /// No description provided for @cardBasisMinimum.
  ///
  /// In ru, this message translates to:
  /// **'вычтен минимум — пойдут проценты'**
  String get cardBasisMinimum;

  /// No description provided for @cardBasisNoFigures.
  ///
  /// In ru, this message translates to:
  /// **'платёж неизвестен — не вычтено'**
  String get cardBasisNoFigures;

  /// No description provided for @cardBasisPlanned.
  ///
  /// In ru, this message translates to:
  /// **'учтён плановый платёж'**
  String get cardBasisPlanned;

  /// No description provided for @cardBasisAfter.
  ///
  /// In ru, this message translates to:
  /// **'срок после конца расчёта — не вычтено'**
  String get cardBasisAfter;

  /// No description provided for @cardBasisSettled.
  ///
  /// In ru, this message translates to:
  /// **'отмечено «внёс»'**
  String get cardBasisSettled;

  /// No description provided for @cardBasisNoDebt.
  ///
  /// In ru, this message translates to:
  /// **'долга нет'**
  String get cardBasisNoDebt;

  /// No description provided for @cardDebtTitle.
  ///
  /// In ru, this message translates to:
  /// **'Долг'**
  String get cardDebtTitle;

  /// No description provided for @bankFiguresTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цифры банка'**
  String get bankFiguresTitle;

  /// No description provided for @bankFiguresMissing.
  ///
  /// In ru, this message translates to:
  /// **'Не указаны — внесите из приложения банка'**
  String get bankFiguresMissing;

  /// No description provided for @cardGraceRow.
  ///
  /// In ru, this message translates to:
  /// **'Без процентов'**
  String get cardGraceRow;

  /// No description provided for @cardMinRow.
  ///
  /// In ru, this message translates to:
  /// **'Минимальный платёж'**
  String get cardMinRow;

  /// No description provided for @dueOnValue.
  ///
  /// In ru, this message translates to:
  /// **'{amount} до {date}'**
  String dueOnValue(String amount, String date);

  /// No description provided for @salaryMarkedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отмечено как полученное'**
  String get salaryMarkedTitle;

  /// No description provided for @salaryMarkedBody.
  ///
  /// In ru, this message translates to:
  /// **'Отметка не меняет остатки счетов. Если деньги пришли на карту, обновите её остаток — тогда они появятся в расчёте.'**
  String get salaryMarkedBody;

  /// No description provided for @salaryMarkedUpdate.
  ///
  /// In ru, this message translates to:
  /// **'Обновить остатки'**
  String get salaryMarkedUpdate;

  /// No description provided for @salaryMarkedDone.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get salaryMarkedDone;

  /// No description provided for @salaryScheduleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Изменить график?'**
  String get salaryScheduleTitle;

  /// No description provided for @salaryScheduleBody.
  ///
  /// In ru, this message translates to:
  /// **'Изменение даты здесь сдвинет её во всех следующих месяцах. Перенести одну задержанную выплату можно будет в следующем обновлении, а пока расчёт идёт на выбранный период.'**
  String get salaryScheduleBody;

  /// No description provided for @salaryScheduleOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть график'**
  String get salaryScheduleOpen;

  /// No description provided for @marksDontChangeBalances.
  ///
  /// In ru, this message translates to:
  /// **'«Оплачено» записывает списание со счёта и сразу меняет остаток. Ошибочную оплату можно отменить, нажав на отметку ещё раз.'**
  String get marksDontChangeBalances;

  /// No description provided for @salarySetup.
  ///
  /// In ru, this message translates to:
  /// **'Настроить зарплату и аванс'**
  String get salarySetup;

  /// No description provided for @salarySetupHint.
  ///
  /// In ru, this message translates to:
  /// **'Даты и суммы выплат — чтобы считать «до зарплаты»'**
  String get salarySetupHint;

  /// No description provided for @addIncomeSource.
  ///
  /// In ru, this message translates to:
  /// **'Добавить ещё работодателя'**
  String get addIncomeSource;

  /// No description provided for @otherIncomesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Другие доходы'**
  String get otherIncomesTitle;

  /// No description provided for @scheduleTitleNew.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата и аванс'**
  String get scheduleTitleNew;

  /// No description provided for @scheduleTitleEdit.
  ///
  /// In ru, this message translates to:
  /// **'График выплат'**
  String get scheduleTitleEdit;

  /// No description provided for @sourceName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get sourceName;

  /// No description provided for @sourceNameDefault.
  ///
  /// In ru, this message translates to:
  /// **'Работа'**
  String get sourceNameDefault;

  /// No description provided for @paymentsPerMonth.
  ///
  /// In ru, this message translates to:
  /// **'Выплат в месяц'**
  String get paymentsPerMonth;

  /// No description provided for @onePayment.
  ///
  /// In ru, this message translates to:
  /// **'Одна'**
  String get onePayment;

  /// No description provided for @twoPayments.
  ///
  /// In ru, this message translates to:
  /// **'Две'**
  String get twoPayments;

  /// No description provided for @partLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название выплаты'**
  String get partLabel;

  /// No description provided for @partDay.
  ///
  /// In ru, this message translates to:
  /// **'Число месяца'**
  String get partDay;

  /// No description provided for @partAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get partAmount;

  /// No description provided for @advanceDefault.
  ///
  /// In ru, this message translates to:
  /// **'Аванс'**
  String get advanceDefault;

  /// No description provided for @salaryDefault.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата'**
  String get salaryDefault;

  /// No description provided for @dayHint.
  ///
  /// In ru, this message translates to:
  /// **'31 — последний день месяца'**
  String get dayHint;

  /// No description provided for @invalidDay.
  ///
  /// In ru, this message translates to:
  /// **'Укажите число от 1 до 31'**
  String get invalidDay;

  /// No description provided for @invalidLabel.
  ///
  /// In ru, this message translates to:
  /// **'Укажите название'**
  String get invalidLabel;

  /// No description provided for @incomeAccount.
  ///
  /// In ru, this message translates to:
  /// **'Куда приходит'**
  String get incomeAccount;

  /// No description provided for @incomeAccountNone.
  ///
  /// In ru, this message translates to:
  /// **'Не выбрано'**
  String get incomeAccountNone;

  /// No description provided for @holidayRuleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Если дата выпала на выходной'**
  String get holidayRuleTitle;

  /// No description provided for @holidayPrevious.
  ///
  /// In ru, this message translates to:
  /// **'В предыдущий рабочий день'**
  String get holidayPrevious;

  /// No description provided for @holidayNext.
  ///
  /// In ru, this message translates to:
  /// **'В следующий рабочий день'**
  String get holidayNext;

  /// No description provided for @holidayNone.
  ///
  /// In ru, this message translates to:
  /// **'Не переносить'**
  String get holidayNone;

  /// No description provided for @holidayHint.
  ///
  /// In ru, this message translates to:
  /// **'По Трудовому кодексу (ст. 136) зарплату выплачивают накануне выходного или праздника.'**
  String get holidayHint;

  /// No description provided for @scheduleEditNote.
  ///
  /// In ru, this message translates to:
  /// **'Изменения действуют с сегодняшнего дня. Прошлые выплаты и полученные деньги не меняются.'**
  String get scheduleEditNote;

  /// No description provided for @archiveSource.
  ///
  /// In ru, this message translates to:
  /// **'Удалить этот доход'**
  String get archiveSource;

  /// No description provided for @archiveSourceConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Новые выплаты перестанут ожидаться. Полученные деньги и история останутся.'**
  String get archiveSourceConfirm;

  /// No description provided for @scheduleLine.
  ///
  /// In ru, this message translates to:
  /// **'{day}-го · {amount}'**
  String scheduleLine(int day, String amount);

  /// No description provided for @paymentPlan.
  ///
  /// In ru, this message translates to:
  /// **'По графику'**
  String get paymentPlan;

  /// No description provided for @paymentExpected.
  ///
  /// In ru, this message translates to:
  /// **'Ожидается'**
  String get paymentExpected;

  /// No description provided for @paymentReceivedTotal.
  ///
  /// In ru, this message translates to:
  /// **'Получено'**
  String get paymentReceivedTotal;

  /// No description provided for @paymentRemaining.
  ///
  /// In ru, this message translates to:
  /// **'Осталось получить'**
  String get paymentRemaining;

  /// No description provided for @paymentHolidayMoved.
  ///
  /// In ru, this message translates to:
  /// **'перенос с {date} из-за выходного'**
  String paymentHolidayMoved(String date);

  /// No description provided for @dateUnknownValue.
  ///
  /// In ru, this message translates to:
  /// **'Дата неизвестна'**
  String get dateUnknownValue;

  /// No description provided for @receiptsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поступления'**
  String get receiptsTitle;

  /// No description provided for @receiptCancelled.
  ///
  /// In ru, this message translates to:
  /// **'отменено'**
  String get receiptCancelled;

  /// No description provided for @cancelReceipt.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get cancelReceipt;

  /// No description provided for @cancelReceiptConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отменить это поступление? Остаток счёта изменится обратно (если остаток уже подтверждён — сумма вернётся в неясную разницу). Запись останется в истории.'**
  String get cancelReceiptConfirm;

  /// No description provided for @actionReceived.
  ///
  /// In ru, this message translates to:
  /// **'Получено'**
  String get actionReceived;

  /// No description provided for @actionMove.
  ///
  /// In ru, this message translates to:
  /// **'Перенести'**
  String get actionMove;

  /// No description provided for @actionUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Не знаю когда'**
  String get actionUnknown;

  /// No description provided for @actionCancelPayment.
  ///
  /// In ru, this message translates to:
  /// **'Не будет'**
  String get actionCancelPayment;

  /// No description provided for @actionReopen.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть'**
  String get actionReopen;

  /// No description provided for @actionChangeAmount.
  ///
  /// In ru, this message translates to:
  /// **'Изменить сумму'**
  String get actionChangeAmount;

  /// No description provided for @actionDetails.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее'**
  String get actionDetails;

  /// No description provided for @cancelPaymentConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отметить, что этой выплаты не будет? Расчёт перестанет её ждать.'**
  String get cancelPaymentConfirm;

  /// No description provided for @stateReceived.
  ///
  /// In ru, this message translates to:
  /// **'Получена'**
  String get stateReceived;

  /// No description provided for @stateCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Не будет'**
  String get stateCancelled;

  /// No description provided for @stateLegacy.
  ///
  /// In ru, this message translates to:
  /// **'Отмечена до обновления'**
  String get stateLegacy;

  /// No description provided for @stateWaiting.
  ///
  /// In ru, this message translates to:
  /// **'Ожидается'**
  String get stateWaiting;

  /// No description provided for @stateOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Задерживается'**
  String get stateOverdue;

  /// No description provided for @statePartial.
  ///
  /// In ru, this message translates to:
  /// **'Получена частично'**
  String get statePartial;

  /// No description provided for @receiveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Получено'**
  String get receiveTitle;

  /// No description provided for @receiveAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сколько пришло'**
  String get receiveAmount;

  /// No description provided for @receiveAccount.
  ///
  /// In ru, this message translates to:
  /// **'На какой счёт'**
  String get receiveAccount;

  /// No description provided for @receiveDate.
  ///
  /// In ru, this message translates to:
  /// **'Когда пришло'**
  String get receiveDate;

  /// No description provided for @receiveCheck.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте перед записью'**
  String get receiveCheck;

  /// No description provided for @receiveBalanceChange.
  ///
  /// In ru, this message translates to:
  /// **'Остаток «{account}»: было {before}, станет {after}'**
  String receiveBalanceChange(String account, String before, String after);

  /// No description provided for @receiveLess.
  ///
  /// In ru, this message translates to:
  /// **'Ожидалось {expected}'**
  String receiveLess(String expected);

  /// No description provided for @restLater.
  ///
  /// In ru, this message translates to:
  /// **'Остальное придёт позже'**
  String get restLater;

  /// No description provided for @wholePayment.
  ///
  /// In ru, this message translates to:
  /// **'Это вся выплата'**
  String get wholePayment;

  /// No description provided for @restDate.
  ///
  /// In ru, this message translates to:
  /// **'Когда ждать остальное'**
  String get restDate;

  /// No description provided for @restUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Не знаю'**
  String get restUnknown;

  /// No description provided for @receiveConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get receiveConfirm;

  /// No description provided for @receiveNoAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Сначала добавьте счёт, на который приходит зарплата'**
  String get receiveNoAccounts;

  /// No description provided for @receiveFuture.
  ///
  /// In ru, this message translates to:
  /// **'Дата не может быть в будущем'**
  String get receiveFuture;

  /// No description provided for @incomeOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Выплата «{label}» {date} ещё не получена. Пока её нет, не прибавляем и считаем на выбранный период.'**
  String incomeOverdue(String label, String date);

  /// No description provided for @incomeUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Выплата «{label}» задерживается, дата неизвестна — считаем на выбранный период.'**
  String incomeUnknown(String label);

  /// No description provided for @incomeDelayed.
  ///
  /// In ru, this message translates to:
  /// **'Выплата «{label}» перенесена на {date}: в день ≈ {perDay} вместо {before}.'**
  String incomeDelayed(String label, String date, String perDay, String before);

  /// No description provided for @incomeDelayedSimple.
  ///
  /// In ru, this message translates to:
  /// **'Выплата «{label}» перенесена на {date}.'**
  String incomeDelayedSimple(String label, String date);

  /// No description provided for @incomePartial.
  ///
  /// In ru, this message translates to:
  /// **'«{label}»: получено {received} из {expected}, остальное ждём.'**
  String incomePartial(String label, String received, String expected);

  /// No description provided for @actionSetDate.
  ///
  /// In ru, this message translates to:
  /// **'Указать дату'**
  String get actionSetDate;

  /// No description provided for @incomeDue.
  ///
  /// In ru, this message translates to:
  /// **'{date}'**
  String incomeDue(String date);

  /// No description provided for @paymentNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Выплата не найдена — возможно, график изменился.'**
  String get paymentNotFound;

  /// No description provided for @storageUpgrade.
  ///
  /// In ru, this message translates to:
  /// **'Нужно обновить данные — откройте «Главную».'**
  String get storageUpgrade;

  /// No description provided for @upgradeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновление данных'**
  String get upgradeTitle;

  /// No description provided for @upgradeText.
  ///
  /// In ru, this message translates to:
  /// **'В новой версии зарплата и аванс, операции и категории хранятся по-новому. Перед обновлением сохраните резервную копию: приложение проверит её сразу после создания. Ваши данные пока не изменены.'**
  String get upgradeText;

  /// No description provided for @upgradeBackup.
  ///
  /// In ru, this message translates to:
  /// **'Создать и проверить копию'**
  String get upgradeBackup;

  /// No description provided for @upgradeBackupDone.
  ///
  /// In ru, this message translates to:
  /// **'Копия создана и проверена: счетов {accounts}, записей журнала {entries}. Сохраните файл в надёжное место.'**
  String upgradeBackupDone(int accounts, int entries);

  /// No description provided for @upgradeBackupFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось создать копию. Данные не изменены — попробуйте ещё раз.'**
  String get upgradeBackupFailed;

  /// No description provided for @upgradeContinue.
  ///
  /// In ru, this message translates to:
  /// **'Обновить данные'**
  String get upgradeContinue;

  /// No description provided for @upgradeWithoutBackup.
  ///
  /// In ru, this message translates to:
  /// **'Обновить без копии?'**
  String get upgradeWithoutBackup;

  /// No description provided for @upgradeWithoutBackupText.
  ///
  /// In ru, this message translates to:
  /// **'На телефоне останется зашифрованная копия базы до обновления, но перенести её на другое устройство нельзя. Рекомендуем сначала создать копию.'**
  String get upgradeWithoutBackupText;

  /// No description provided for @upgradeAnyway.
  ///
  /// In ru, this message translates to:
  /// **'Обновить без копии'**
  String get upgradeAnyway;

  /// No description provided for @upgradeAutoCopy.
  ///
  /// In ru, this message translates to:
  /// **'При обновлении на телефоне автоматически сохраняется зашифрованная копия старой базы.'**
  String get upgradeAutoCopy;

  /// No description provided for @otherIncomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Другой доход'**
  String get otherIncomeTitle;

  /// No description provided for @otherIncomeHint.
  ///
  /// In ru, this message translates to:
  /// **'Подработка, кэшбэк, возврат налога и другие поступления. Зарплату и аванс добавляйте через «Зарплата и аванс» — там учитываются задержки, частичные выплаты и выходные.'**
  String get otherIncomeHint;

  /// No description provided for @addIncomeWhat.
  ///
  /// In ru, this message translates to:
  /// **'Какой доход добавить?'**
  String get addIncomeWhat;

  /// No description provided for @sheetSalary.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата и аванс'**
  String get sheetSalary;

  /// No description provided for @sheetSalaryMore.
  ///
  /// In ru, this message translates to:
  /// **'Ещё одна зарплата (другой работодатель)'**
  String get sheetSalaryMore;

  /// No description provided for @sheetOtherIncome.
  ///
  /// In ru, this message translates to:
  /// **'Другой доход'**
  String get sheetOtherIncome;

  /// No description provided for @otherIncomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Другой доход · {cadence}'**
  String otherIncomeSubtitle(String cadence);

  /// No description provided for @partDayShort.
  ///
  /// In ru, this message translates to:
  /// **'Число'**
  String get partDayShort;

  /// No description provided for @partDayPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'1–31'**
  String get partDayPlaceholder;

  /// No description provided for @partAmountPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'0'**
  String get partAmountPlaceholder;

  /// No description provided for @partLabelPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get partLabelPlaceholder;

  /// No description provided for @payTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оплачено'**
  String get payTitle;

  /// No description provided for @payAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сколько заплатили'**
  String get payAmount;

  /// No description provided for @payAccount.
  ///
  /// In ru, this message translates to:
  /// **'С какого счёта'**
  String get payAccount;

  /// No description provided for @payDate.
  ///
  /// In ru, this message translates to:
  /// **'Когда заплатили'**
  String get payDate;

  /// No description provided for @payDue.
  ///
  /// In ru, this message translates to:
  /// **'Срок: {date}'**
  String payDue(String date);

  /// No description provided for @payTransferNote.
  ///
  /// In ru, this message translates to:
  /// **'Это перевод между вашими счетами: долг уменьшится, расходом это не считается.'**
  String get payTransferNote;

  /// No description provided for @payBalanceChange.
  ///
  /// In ru, this message translates to:
  /// **'Остаток «{account}»: было {before}, станет {after}'**
  String payBalanceChange(String account, String before, String after);

  /// No description provided for @payDebtChange.
  ///
  /// In ru, this message translates to:
  /// **'Долг «{account}»: было {before}, станет {after}'**
  String payDebtChange(String account, String before, String after);

  /// No description provided for @similarFound.
  ///
  /// In ru, this message translates to:
  /// **'На этом счёте уже есть похожая операция: {date}, {amount}{what}. Возможно, этот платёж уже записан.'**
  String similarFound(String date, String amount, String what);

  /// No description provided for @similarConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Это другая оплата — записать'**
  String get similarConfirm;

  /// No description provided for @payConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить оплату'**
  String get payConfirm;

  /// No description provided for @paySkip.
  ///
  /// In ru, this message translates to:
  /// **'Платежа не будет'**
  String get paySkip;

  /// No description provided for @paySkipConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отметить, что этого платежа не будет? Он перестанет учитываться в обязательных. Деньги со счёта не списываются.'**
  String get paySkipConfirm;

  /// No description provided for @payAlreadyPaid.
  ///
  /// In ru, this message translates to:
  /// **'Этот платёж уже оплачен.'**
  String get payAlreadyPaid;

  /// No description provided for @payFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось записать оплату. Ничего не изменилось.'**
  String get payFailed;

  /// No description provided for @paidInfo.
  ///
  /// In ru, this message translates to:
  /// **'Оплачено {date} · {amount}{account}'**
  String paidInfo(String date, String amount, String account);

  /// No description provided for @cancelPaymentAction.
  ///
  /// In ru, this message translates to:
  /// **'Отменить оплату'**
  String get cancelPaymentAction;

  /// No description provided for @cancelPaymentText.
  ///
  /// In ru, this message translates to:
  /// **'Отменить эту оплату? Операция будет сторнирована, остаток вернётся, платёж снова станет обязательным. Запись останется в истории.'**
  String get cancelPaymentText;

  /// No description provided for @skippedInfo.
  ///
  /// In ru, this message translates to:
  /// **'Отмечено: платежа не будет'**
  String get skippedInfo;

  /// No description provided for @unskipAction.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть платёж'**
  String get unskipAction;

  /// No description provided for @overdueLabel.
  ///
  /// In ru, this message translates to:
  /// **'просрочен'**
  String get overdueLabel;

  /// No description provided for @legacyMarkLabel.
  ///
  /// In ru, this message translates to:
  /// **'отмечено до обновления — подтвердите оплату'**
  String get legacyMarkLabel;

  /// No description provided for @fixPaymentOverdue.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» {date} не оплачен — он остаётся в обязательных, пока вы его не оплатите или не отметите, что платежа не будет.'**
  String fixPaymentOverdue(String name, String date);

  /// No description provided for @pendingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оплаты после прошлого обновления'**
  String get pendingTitle;

  /// No description provided for @pendingHint.
  ///
  /// In ru, this message translates to:
  /// **'Ответьте по каждому счёту, который сверяете сейчас. Иначе остаток посчитается неверно.'**
  String get pendingHint;

  /// No description provided for @pendingLine.
  ///
  /// In ru, this message translates to:
  /// **'{title} · {amount} · {date}'**
  String pendingLine(String title, String amount, String date);

  /// No description provided for @pendingDebitQuestion.
  ///
  /// In ru, this message translates to:
  /// **'«{account}»: Банк уже списал деньги?'**
  String pendingDebitQuestion(String account);

  /// No description provided for @pendingCreditQuestion.
  ///
  /// In ru, this message translates to:
  /// **'«{account}»: Банк уже зачислил перевод?'**
  String pendingCreditQuestion(String account);

  /// No description provided for @pendingDebited.
  ///
  /// In ru, this message translates to:
  /// **'Уже списано'**
  String get pendingDebited;

  /// No description provided for @pendingNotYet.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не списано'**
  String get pendingNotYet;

  /// No description provided for @pendingCredited.
  ///
  /// In ru, this message translates to:
  /// **'Уже зачислено'**
  String get pendingCredited;

  /// No description provided for @pendingNotYetCredited.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не зачислено'**
  String get pendingNotYetCredited;

  /// No description provided for @pendingNeedAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Ответьте на каждый вопрос выше'**
  String get pendingNeedAnswer;

  /// No description provided for @payNoAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Сначала добавьте счёт, с которого платите'**
  String get payNoAccounts;

  /// No description provided for @confirmBalanceQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Остаток «{account}» подтверждён {when} — в день операции или позже. Эта операция уже была в нём?'**
  String confirmBalanceQuestion(String account, String when);

  /// No description provided for @confirmDebtQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Долг «{account}» подтверждён {when} — в день операции или позже. Этот платёж уже был в нём учтён?'**
  String confirmDebtQuestion(String account, String when);

  /// No description provided for @confirmYes.
  ///
  /// In ru, this message translates to:
  /// **'Уже была'**
  String get confirmYes;

  /// No description provided for @confirmNo.
  ///
  /// In ru, this message translates to:
  /// **'Ещё нет'**
  String get confirmNo;

  /// No description provided for @figuresQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Сумма к оплате {due}, введённая {date}, уже учитывает этот платёж?'**
  String figuresQuestion(String due, String date);

  /// No description provided for @figuresYes.
  ///
  /// In ru, this message translates to:
  /// **'Да, уже учтён'**
  String get figuresYes;

  /// No description provided for @figuresNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет, ещё не учтён'**
  String get figuresNo;

  /// No description provided for @payRecheck.
  ///
  /// In ru, this message translates to:
  /// **'Пока вы отвечали, изменились сверка или цифры банка. Ничего не записано — ответьте на вопросы ещё раз.'**
  String get payRecheck;

  /// No description provided for @payFiguresChanged.
  ///
  /// In ru, this message translates to:
  /// **'Цифры банка по этой кредитке изменились. Ничего не записано — вернитесь и откройте оплату по актуальной сумме.'**
  String get payFiguresChanged;

  /// No description provided for @payBackToPayments.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться'**
  String get payBackToPayments;

  /// No description provided for @enterBankAmount.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму из банка'**
  String get enterBankAmount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
