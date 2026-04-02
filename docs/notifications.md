# Notifications

ExpiryCue uses local notifications only.

Stable identifiers:
- fooditem.<UUID>.d3
- fooditem.<UUID>.d1
- fooditem.<UUID>.d0

Scheduling rules:
- cancel existing requests before rescheduling
- skip past triggers
- cancel all item notifications when an item becomes consumed or discarded
- reschedule all active item notifications when settings change
- cancel all notifications when notifications are disabled

Configuration:
- `notifyDaysBefore` controls the `d3` style reminder offset and defaults to 3 days
- `notifyOneDayBefore` controls the `d1` reminder
- `notifyOnDay` controls the `d0` reminder
- notification time defaults to 09:00 local time

Localization:
- notification title and body are localized in English and German
- localized content is prepared before requests are scheduled
