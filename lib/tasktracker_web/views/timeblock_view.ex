defmodule TasktrackerWeb.TimeblockView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimeblockView

  def render("index.json", %{time_blocks: time_blocks}) do
    %{data: render_many(time_blocks, TimeblockView, "timeblock.json")}
  end

  def render("show.json", %{timeblock: timeblock}) do
    %{data: render_one(timeblock, TimeblockView, "timeblock.json")}
  end

  def render("timeblock.json", %{timeblock: timeblock}) do
    %{id: timeblock.id,
      start: timeblock.start,
      end: timeblock.end}
  end
end
