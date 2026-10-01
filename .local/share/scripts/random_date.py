#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random
from datetime import date, datetime, time, timedelta, timezone
from zoneinfo import ZoneInfo

TZ = ZoneInfo("Europe/Berlin")


def random_asctime_dates(start_iso: str, end_iso: str, max_count: int = 5) -> list[str]:
    start_date = date.fromisoformat(start_iso)
    end_date = date.fromisoformat(end_iso)

    if start_date > end_date:
        raise ValueError("start date must not be after end date")

    # Entire end day is included.
    start_dt = datetime.combine(start_date, time.min, TZ)
    end_dt = datetime.combine(end_date + timedelta(days=1), time.min, TZ)

    start_ts = int(start_dt.astimezone(timezone.utc).timestamp())
    end_ts = int(end_dt.astimezone(timezone.utc).timestamp())

    available = end_ts - start_ts
    if available <= 0:
        return []

    count = min(max_count, available)
    rng = random.SystemRandom()

    timestamps = sorted(rng.sample(range(start_ts, end_ts), count))

    return [
        datetime.fromtimestamp(ts, TZ).strftime("%a %b %d %H:%M:%S %Y %z")
        for ts in timestamps
    ]


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate random asctime dates between two ISO 8601 dates."
    )
    parser.add_argument(
        "start",
        metavar="START",
        help="Start date (YYYY-MM-DD)",
    )
    parser.add_argument(
        "end",
        metavar="END",
        help="End date (YYYY-MM-DD)",
    )
    parser.add_argument(
        "-n",
        "--count",
        type=int,
        default=5,
        help="Number of dates to generate (default: 5)",
    )

    args = parser.parse_args()

    if args.count < 1:
        parser.error("--count must be at least 1")

    try:
        for d in random_asctime_dates(args.start, args.end, args.count):
            print(d)
    except ValueError as e:
        parser.error(str(e))


if __name__ == "__main__":
    main()
