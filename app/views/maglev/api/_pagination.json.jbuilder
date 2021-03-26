# frozen_string_literal: true

json.next url_for(page: records.next_page) unless records.last_page?
json.prev url_for(page: records.prev_page) unless records.first_page?
json.total_pages records.total_pages
json.total_items records.total_count
