// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import "bootstrap";
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(function () {
  $('#new-block-button').click((ev) => {
    let start = $('#new-block-start').val();
    let end = $('#new-block-end').val();
    let user_id = $(ev.target).data('user-id');
    let task_id = $(ev.target).data('task-id');

    let text = JSON.stringify({
      timeblock: {
	user_id: user_id,
	task_id: task_id,
	start: start,
	end: end,
      },
    });

    $.ajax("/time_blocks", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
	$('#new-block-form').text(`(${resp.data.start} - ${resp.data.end})`);
      },
    });
  });
});
