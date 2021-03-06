//*****************************************************************************
// File: NetworkNICMap.cs
// Project: Microsoft.WindowsAzurePack.CmpWapExtension.Api
// Purpose: Model Mapping for NetworkNICs
// Copyright (c) Microsoft Corporation.  All rights reserved.
//*****************************************************************************

using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace Microsoft.WindowsAzurePack.CmpWapExtension.Api.Models.Mapping
{
    public class NetworkNICMap : EntityTypeConfiguration<NetworkNIC>
    {
        public NetworkNICMap()
        {
            // Primary Key
            this.HasKey(t => t.NetworkNICId);

            // Properties
            this.Property(t => t.NetworkNICId)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.Name)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.Description)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.CreatedBy)
                .IsRequired()
                .HasMaxLength(256);

            this.Property(t => t.LastUpdatedBy)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.ADDomain)
                .HasMaxLength(256);

            this.Property(t => t.ADDomainId);

            // Table & Column Mappings
            this.ToTable("NetworkNIC");
            this.Property(t => t.NetworkNICId).HasColumnName("NetworkNICId");
            this.Property(t => t.Name).HasColumnName("Name");
            this.Property(t => t.Description).HasColumnName("Description");
            this.Property(t => t.IsActive).HasColumnName("IsActive");
            this.Property(t => t.CreatedOn).HasColumnName("CreatedOn");
            this.Property(t => t.CreatedBy).HasColumnName("CreatedBy");
            this.Property(t => t.LastUpdatedOn).HasColumnName("LastUpdatedOn");
            this.Property(t => t.LastUpdatedBy).HasColumnName("LastUpdatedBy");
            this.Property(t => t.ADDomain).HasColumnName("ADDomain");
            this.Property(t => t.ADDomainId).HasColumnName("ADDomainId");
        }
    }
}
