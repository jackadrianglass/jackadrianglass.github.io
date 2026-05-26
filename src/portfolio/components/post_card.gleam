import blogatto/post.{type Post}
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import gleam/time/calendar
import gleam/time/timestamp
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn parse_tags(raw: String) -> List(String) {
  raw
  |> string.drop_start(1)
  |> string.drop_end(1)
  |> string.split(",")
  |> list.map(fn(token) {
    token
    |> string.trim
    |> string.drop_start(1)
    |> string.drop_end(1)
  })
  |> list.filter(fn(t) { t != "" })
}

pub fn is_project_post(p: Post(Nil)) -> Bool {
  dict.get(p.extras, "type") == Ok("project")
}

fn pad2(n: Int) -> String {
  let s = int.to_string(n)
  case string.length(s) < 2 {
    True -> "0" <> s
    False -> s
  }
}

fn month_number(month: calendar.Month) -> Int {
  case month {
    calendar.January -> 1
    calendar.February -> 2
    calendar.March -> 3
    calendar.April -> 4
    calendar.May -> 5
    calendar.June -> 6
    calendar.July -> 7
    calendar.August -> 8
    calendar.September -> 9
    calendar.October -> 10
    calendar.November -> 11
    calendar.December -> 12
  }
}

fn format_date(ts: timestamp.Timestamp) -> String {
  let #(date, _) = timestamp.to_calendar(ts, calendar.utc_offset)
  int.to_string(date.year)
  <> "-"
  <> pad2(month_number(date.month))
  <> "-"
  <> pad2(date.day)
}

pub fn post_card(p: Post(Nil)) -> Element(Nil) {
  let tags =
    dict.get(p.extras, "tags")
    |> option.from_result
    |> option.map(parse_tags)
    |> option.unwrap([])

  html.li([attribute.class("c-post-list__item")], [
    html.article([attribute.class("c-post-card")], [
      html.a(
        [
          attribute.href("/pages/" <> p.slug <> "/"),
          attribute.class("c-post-card__title"),
        ],
        [element.text(p.title)],
      ),
      html.p([attribute.class("c-post-card__date")], [
        html.em([], [element.text(format_date(p.date))]),
      ]),
      html.p([attribute.class("c-post-card__description")], [
        element.text(p.description),
      ]),
      case tags {
        [] -> element.none()
        _ -> tag_list(tags)
      },
    ]),
  ])
}

pub fn tag_list(tags: List(String)) -> Element(Nil) {
  html.ul(
    [attribute.class("c-tag-list")],
    list.map(tags, fn(tag) {
      html.li([attribute.class("c-tag")], [element.text(tag)])
    }),
  )
}
