defmodule Rath.Repo.Migrations.ProductThing do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :pr_name, :text, null: false
      add :pr_slug, :text, null: false
      add :original_price, :integer, null: false
      add :sales_price, :integer, null: false

      timestamps()
    end

    create table(:categories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :text, null: false
      add :description, :text, null: false

      timestamps()
    end


    create table(:inventories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :quantity, :integer, null: false

      timestamps()
    end

    create table(:discounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :discount_name, :text, null: false
      add :discount_desc, :text, null: false
      add :discount_amout, :integer, null: false
      add :active, :boolean, null: false, default: false

      timestamps()
    end

    alter table(:products) do
      add :category_id, references(:categories, type: :uuid, on_delete: :nilify_all)
      add :inventory_id, references(:inventories, type: :uuid, on_delete: :nilify_all)
      add :discount_id, references(:discounts, type: :uuid, on_delete: :nilify_all)
    end

    create unique_index(:products, [:category_id])
    create unique_index(:products, [:inventory_id])
    create unique_index(:products, [:discount_id])
  end
end
