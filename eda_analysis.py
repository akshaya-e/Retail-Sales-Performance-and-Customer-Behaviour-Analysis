import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set professional styling theme
sns.set_theme(style="whitegrid")
plt.rcParams.update({'figure.autolayout': True})

FILE_PATH = "Retail-Sales-Dataset.xlsx"
SHEET_NAME = "Retails Order Full Dataset"
OUTPUT_DIR = "eda_outputs"


def export_chart(file_name):
    """Save chart to output folder and close figure."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    out_path = os.path.join(OUTPUT_DIR, file_name)
    plt.savefig(out_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Chart saved: {out_path}")


def load_dataset():
    """Load dataset from Excel file."""
    df = pd.read_excel(FILE_PATH, sheet_name=SHEET_NAME, parse_dates=['Order Date', 'Ship Date'])
    return df


def generate_dashboard_visualizations(df):
    print("--- GENERATING DASHBOARD VISUALIZATIONS ---")

    # 1. Sales and Profit by Category
    plt.figure(figsize=(10, 6))
    cat_agg = df.groupby('Category')[['Sales', 'Profit']].sum().reset_index()
    cat_melted = cat_agg.melt(id_vars='Category', value_vars=['Sales', 'Profit'], 
                              var_name='Metric', value_name='Amount')
    sns.barplot(data=cat_melted, x='Category', y='Amount', hue='Metric', palette=['#2563EB', '#F97316'])
    plt.title('Sales and Profit by Category', fontsize=14, fontweight='bold')
    plt.ylabel('Amount ($)', fontsize=12)
    plt.xlabel('Category', fontsize=12)
    export_chart('sales_profit_by_category.png')

    # 2. Trend of Sales over Time (Monthly Sales)
    plt.figure(figsize=(12, 6))
    monthly_sales = df.groupby(df['Order Date'].dt.to_period('M'))['Sales'].sum().reset_index()
    monthly_sales['Order Date'] = monthly_sales['Order Date'].dt.to_timestamp()
    sns.lineplot(data=monthly_sales, x='Order Date', y='Sales', color='#2563EB', linewidth=2.5, marker='o')
    plt.title('Trend of Sales over Time', fontsize=14, fontweight='bold')
    plt.ylabel('Sales ($)', fontsize=12)
    plt.xlabel('Date', fontsize=12)
    plt.xticks(rotation=45)
    export_chart('monthly_sales_trend.png')

    # 3. Top 5 Products by Sales
    plt.figure(figsize=(11, 6))
    top_prod = df.groupby('Product Name')['Sales'].sum().nlargest(5).reset_index()

    top_prod['Short Name'] = top_prod['Product Name'].str.slice(0, 35) + '...'
    sns.barplot(data=top_prod, x='Sales', y='Short Name', hue='Short Name', palette='Blues_r', legend=False)
    plt.title('Top 5 Products by Sales', fontsize=14, fontweight='bold')
    plt.xlabel('Sales ($)', fontsize=12)
    plt.ylabel('Product Name', fontsize=12)
    export_chart('top_products_sales.png')

    # 4. Top 5 Customers by Sales
    plt.figure(figsize=(11, 6))
    top_cust = df.groupby('Customer Name')['Sales'].sum().nlargest(5).reset_index()
    sns.barplot(data=top_cust, x='Sales', y='Customer Name', hue='Customer Name', palette='Blues_r', legend=False)
    plt.title('Top 5 Customers by Sales', fontsize=14, fontweight='bold')
    plt.xlabel('Sales ($)', fontsize=12)
    plt.ylabel('Customer Name', fontsize=12)
    export_chart('top_customers_sales.png')

    # 5. Quantity vs Profit
    plt.figure(figsize=(10, 6))
    sns.scatterplot(data=df, x='Quantity', y='Profit', alpha=0.4, color='#2563EB')
    sns.regplot(data=df, x='Quantity', y='Profit', scatter=False, color='#DC2626')
    plt.title('Quantity vs Profit', fontsize=14, fontweight='bold')
    plt.xlabel('Sum of Quantity', fontsize=12)
    plt.ylabel('Sum of Profit', fontsize=12)
    export_chart('quantity_vs_profit.png')


if __name__ == '__main__':
    dataframe = load_dataset()
    generate_dashboard_visualizations(dataframe)
    print("\nAll dashboard charts generated successfully!")