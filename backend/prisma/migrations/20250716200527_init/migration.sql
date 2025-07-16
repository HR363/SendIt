BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] NVARCHAR(1000) NOT NULL,
    [email] NVARCHAR(1000) NOT NULL,
    [firstName] NVARCHAR(1000) NOT NULL,
    [lastName] NVARCHAR(1000) NOT NULL,
    [phone] NVARCHAR(1000) NOT NULL,
    [password] NVARCHAR(1000) NOT NULL,
    [role] NVARCHAR(1000) NOT NULL,
    [isActive] BIT NOT NULL CONSTRAINT [User_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [User_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [deletedAt] DATETIME2,
    CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [User_email_key] UNIQUE NONCLUSTERED ([email]),
    CONSTRAINT [User_phone_key] UNIQUE NONCLUSTERED ([phone])
);

-- CreateTable
CREATE TABLE [dbo].[ParcelCategory] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [description] NVARCHAR(1000),
    [minWeight] DECIMAL(32,16) NOT NULL,
    [maxWeight] DECIMAL(32,16) NOT NULL,
    [pricePerKg] DECIMAL(32,16) NOT NULL,
    [basePrice] DECIMAL(32,16) NOT NULL,
    [isActive] BIT NOT NULL CONSTRAINT [ParcelCategory_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ParcelCategory_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [deletedAt] DATETIME2,
    CONSTRAINT [ParcelCategory_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Parcel] (
    [id] NVARCHAR(1000) NOT NULL,
    [trackingNumber] NVARCHAR(1000) NOT NULL,
    [senderId] NVARCHAR(1000) NOT NULL,
    [receiverId] NVARCHAR(1000) NOT NULL,
    [categoryId] NVARCHAR(1000) NOT NULL,
    [createdById] NVARCHAR(1000) NOT NULL,
    [assignedCourierId] NVARCHAR(1000),
    [senderName] NVARCHAR(1000) NOT NULL,
    [senderPhone] NVARCHAR(1000) NOT NULL,
    [senderEmail] NVARCHAR(1000) NOT NULL,
    [receiverName] NVARCHAR(1000) NOT NULL,
    [receiverPhone] NVARCHAR(1000) NOT NULL,
    [receiverEmail] NVARCHAR(1000) NOT NULL,
    [pickupLocation] NVARCHAR(1000) NOT NULL,
    [destinationLocation] NVARCHAR(1000) NOT NULL,
    [weight] DECIMAL(32,16) NOT NULL,
    [description] NVARCHAR(1000),
    [status] NVARCHAR(1000) NOT NULL,
    [estimatedDeliveryDate] DATETIME2 NOT NULL,
    [actualDeliveryDate] DATETIME2,
    [price] DECIMAL(32,16) NOT NULL,
    [deliveryImage] NVARCHAR(1000),
    [isActive] BIT NOT NULL CONSTRAINT [Parcel_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Parcel_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [deletedAt] DATETIME2,
    CONSTRAINT [Parcel_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Parcel_trackingNumber_key] UNIQUE NONCLUSTERED ([trackingNumber])
);

-- CreateTable
CREATE TABLE [dbo].[Review] (
    [id] NVARCHAR(1000) NOT NULL,
    [userId] NVARCHAR(1000) NOT NULL,
    [parcelId] NVARCHAR(1000) NOT NULL,
    [rating] INT NOT NULL,
    [comment] NVARCHAR(1000),
    [isActive] BIT NOT NULL CONSTRAINT [Review_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Review_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [deletedAt] DATETIME2,
    CONSTRAINT [Review_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ParcelStatusHistory] (
    [id] NVARCHAR(1000) NOT NULL,
    [parcelId] NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(1000) NOT NULL,
    [location] NVARCHAR(1000) NOT NULL,
    [notes] NVARCHAR(1000),
    [updatedById] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ParcelStatusHistory_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [ParcelStatusHistory_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[Parcel] ADD CONSTRAINT [Parcel_senderId_fkey] FOREIGN KEY ([senderId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Parcel] ADD CONSTRAINT [Parcel_receiverId_fkey] FOREIGN KEY ([receiverId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Parcel] ADD CONSTRAINT [Parcel_categoryId_fkey] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[ParcelCategory]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Parcel] ADD CONSTRAINT [Parcel_createdById_fkey] FOREIGN KEY ([createdById]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Parcel] ADD CONSTRAINT [Parcel_assignedCourierId_fkey] FOREIGN KEY ([assignedCourierId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Review] ADD CONSTRAINT [Review_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Review] ADD CONSTRAINT [Review_parcelId_fkey] FOREIGN KEY ([parcelId]) REFERENCES [dbo].[Parcel]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ParcelStatusHistory] ADD CONSTRAINT [ParcelStatusHistory_parcelId_fkey] FOREIGN KEY ([parcelId]) REFERENCES [dbo].[Parcel]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ParcelStatusHistory] ADD CONSTRAINT [ParcelStatusHistory_updatedById_fkey] FOREIGN KEY ([updatedById]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
