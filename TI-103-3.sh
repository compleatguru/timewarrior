#!/bin/bash

TODAY=$(date "+%Y%m%d")
YESTERDAY=$(date -d "yesterday" "+%Y%m%d")
CURRENT_HOUR=$(date +%k)

function get_current_date_with_delta()
{
  local delta=${1}

  let "hour = CURRENT_HOUR + delta"

  if [[ ${hour} -lt 0 ]] ; then
    let "hour = hour + 24"
    day=${YESTERDAY}
  else
    day=${TODAY}
  fi

  if [[ ${hour} -lt 10 ]] ; then
    hour="0${hour}"
  fi

  echo "${day}T${hour}0000"
}

export TIMEWARRIORDB=/home/lauft/Projects/timew/timewarriordb
rm -f ${TIMEWARRIORDB}/data/*.data
:> ${TIMEWARRIORDB}/timewarrior.cfg

cat <<EOF > ${TIMEWARRIORDB}/timewarrior.cfg
exclusions.monday    = <9:00 >20:00
exclusions.tuesday   = <9:00 >20:00
exclusions.wednesday = <9:00 >20:00
exclusions.thursday  = <9:00 >20:00
exclusions.friday    = <9:00 >20:00
exclusions.saturday  = <9:00 >20:00
exclusions.sunday    = <9:00 >20:00
reports.day.hours = auto
reports.week.hours = auto
reports.month.hours = auto
EOF

five_hours_before=$(get_current_date_with_delta "-5")
four_hours_before=$(get_current_date_with_delta "-4")
three_hours_before=$(get_current_date_with_delta "-3")
two_hours_before=$(get_current_date_with_delta "-2")
one_hour_before=$(get_current_date_with_delta "-1") 
current_hour=$(get_current_date_with_delta "0")
one_hour_after=$(get_current_date_with_delta "1")
two_hours_after=$(get_current_date_with_delta "2")

src/timew track "${YESTERDAY}T1200" - "${YESTERDAY}T1400" FOO
#src/timew week :month

echo "TI-103.sh: no open interval"