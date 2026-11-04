import 'package:flutter/cupertino.dart';

import '../core/money/money.dart';
import '../core/money/money_text.dart';
import 'theme.dart';

/// A page with an iOS large title that collapses on scroll; content never
/// slides under a translucent bar in a confusing way.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.heroTag,
  });
  final String title;
  final List<Widget> children;
  final Widget? leading;
  final Widget? trailing;

  /// Unique per page: tab pages live side by side in one route.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return CupertinoPageScaffold(
      backgroundColor: p.background,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            heroTag: heroTag ?? 'nav.$title',
            largeTitle: Text(title),
            leading: leading,
            trailing: trailing,
            backgroundColor: p.background.withValues(alpha: 0.92),
            border: null,
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                Space.l,
                Space.s,
                Space.l,
                Space.xxl,
              ),
              sliver: SliverList.list(children: children),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded surface with a soft shadow in light mode.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Space.l),
    this.onTap,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(Space.radius),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: card,
    );
  }
}

/// «26 931,52 ₽» with smaller kopecks and symbol; tabular digits.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.money, {
    super.key,
    this.size = 17,
    this.color,
    this.weight = FontWeight.w600,
    this.prefix = '',
  });
  final Money money;
  final double size;
  final Color? color;
  final FontWeight weight;

  /// Shown before the amount, e.g. «≈ ».
  final String prefix;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Palette.of(context).text;
    final text = formatMoney(money);
    final comma = text.indexOf(',');
    final symbolAt = text.lastIndexOf(' ');
    final split = comma >= 0 ? comma : symbolAt;
    final main = AppText.amount(c, size: size).copyWith(fontWeight: weight);
    final small = main.copyWith(fontSize: size * (size >= 30 ? 0.6 : 0.82));
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: prefix + text.substring(0, split), style: main),
          TextSpan(text: text.substring(split), style: small),
        ],
      ),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}

/// Small rounded label: «● Точный расчёт», «Предварительный расчёт».
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
  });
  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 5),
        ],
        Flexible(child: Text(label, style: AppText.caption(foreground))),
      ],
    ),
  );
}

/// Round tinted icon (account kind, notice type).
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 36,
  });
  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: size * 0.52, color: color),
  );
}

/// Title above a card, with an optional action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    super.key,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.xs, Space.xl, Space.xs, Space.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppText.title(p.text).copyWith(fontSize: 20),
              ),
            ),
          ),
          if (actionLabel != null)
            CupertinoButton(
              key: actionKey,
              padding: EdgeInsets.zero,
              minimumSize: const Size(44, 32),
              onPressed: onAction,
              child: Text(actionLabel!, style: AppText.secondary(p.accent)),
            ),
        ],
      ),
    );
  }
}

enum NoticeTone { warning, info }

/// Compact «what to fix» row: icon, wrapping text, chevron; tappable.
class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.text,
    required this.onTap,
    this.icon = CupertinoIcons.exclamationmark_circle,
    this.tone = NoticeTone.warning,
    this.actions = const [],
  });
  final String text;
  final VoidCallback? onTap;
  final IconData icon;
  final NoticeTone tone;

  /// Buttons under the text (e.g. «Получена» / «Изменить»).
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final color = tone == NoticeTone.warning ? p.warning : p.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.m),
        child: Row(
          children: [
            IconBadge(icon: icon, color: color, size: 32),
            const SizedBox(width: Space.m),
            Expanded(
              child: actions.isEmpty
                  ? Text(text, style: AppText.secondary(p.text))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text, style: AppText.secondary(p.text)),
                        const SizedBox(height: Space.s),
                        Wrap(
                          spacing: Space.s,
                          runSpacing: Space.s,
                          children: actions,
                        ),
                      ],
                    ),
            ),
            if (onTap != null)
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: p.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Rounded action button. [onHero] styles it for the green hero card.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
    this.onHero = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;
  final bool onHero;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final fg = onHero
        ? const Color(0xFFFFFFFF)
        : filled
        ? const Color(0xFFFFFFFF)
        : p.accent;
    final bg = onHero
        ? const Color(0x33FFFFFF)
        : filled
        ? p.accent
        : p.accentSoft;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: onPressed == null ? bg.withValues(alpha: 0.4) : bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: fg),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                style: AppText.headline(fg).copyWith(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small card with a label and an amount (used in pairs).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.amount,
    this.amountKey,
    this.color,
    this.onTap,
  });
  final String label;
  final Money amount;
  final Key? amountKey;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.secondary(p.textSecondary)),
          const SizedBox(height: Space.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: MoneyText(amount, key: amountKey, size: 20, color: color),
          ),
        ],
      ),
    );
  }
}

/// A group of rows in one card with hairline separators.
class CardGroup extends StatelessWidget {
  const CardGroup({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.l),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Container(height: 0.5, color: p.separator),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Settings-style row: title, optional value/subtitle, chevron or trailing.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.value,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.icon,
    this.iconColor,
  });
  final String title;
  final String? value;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.m),
          child: Row(
            children: [
              if (icon != null) ...[
                IconBadge(icon: icon!, color: iconColor ?? p.accent, size: 30),
                const SizedBox(width: Space.m),
              ],
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.body(p.text)),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: AppText.secondary(p.textSecondary),
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Space.s),
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      style: AppText.body(p.textSecondary),
                    ),
                  ),
                ),
              ?trailing,
              if (onTap != null && trailing == null)
                Padding(
                  padding: const EdgeInsets.only(left: Space.s),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: p.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Labelled text field in a card, consistent across forms.
class FormFieldCard extends StatelessWidget {
  const FormFieldCard({
    super.key,
    required this.label,
    required this.child,
    this.error,
    this.hint,
  });
  final String label;
  final Widget child;
  final String? error;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Space.xs, bottom: Space.xs),
            child: Text(label, style: AppText.caption(p.textSecondary)),
          ),
          child,
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(left: Space.xs, top: Space.xs),
              child: Text(hint!, style: AppText.caption(p.textTertiary)),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(left: Space.xs, top: Space.xs),
              child: Text(error!, style: AppText.caption(p.negative)),
            ),
        ],
      ),
    );
  }
}

/// Text field styled to sit on the page background.
BoxDecoration fieldDecoration(BuildContext context) => BoxDecoration(
  color: Palette.of(context).surface,
  borderRadius: BorderRadius.circular(Space.radiusSmall),
);

/// Navigation-bar text: like iOS, bar titles and buttons grow with Dynamic
/// Type only up to a limit so the bar never overflows.
class BarText extends StatelessWidget {
  const BarText(this.text, {super.key, this.style});
  final String text;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: 1.35,
    child: Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
