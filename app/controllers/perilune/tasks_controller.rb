# frozen_string_literal: true

module Perilune
  class TasksController < Perilune::ApplicationController
    before_action :set_resources, only: %i[index]
    before_action :set_resource, only: %i[show]

    def index; end

    def show; end

    private

    def set_resources
      resource_search_operation.perform
      raise resource_search_operation.result.error unless resource_search_operation.success?

      @resources = resource_search_operation.result.value
    end

    def resource_search_operation
      @resource_search_operation ||= Perilune::Tasks::SearchOperation.new(
        query: {},
        limit: {},
        includes: [],
        order: 'id DESC',
        page: params[:page] || 1,
        per: 25,
        domain: :perilune
      )
    end

    def set_resource
      resource_find_operation.perform
      raise resource_find_operation.result.error unless resource_find_operation.success?

      @resource = resource_find_operation.result.value
    end

    def resource_find_operation
      @resource_find_operation ||= Perilune::Tasks::FindOperation.new(
        id: params[:id],
        limit: {},
        domain: :perilune
      )
    end
  end
end
